import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/notification_channels.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/notification_config.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'local_notification_service.g.dart';

/// Service for managing local notifications.
///
/// Provides a clean API for showing, scheduling, and managing notifications.
class LocalNotificationService {
  /// Creates a [LocalNotificationService] instance.
  new(this._ref);

  final Ref _ref;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  AppLogger get _logger => _ref.read(loggerProvider);

  bool _isInitialized = false;
  String? _pendingDeepLink;

  final _notificationTapController =
      StreamController<NotificationResponse>.broadcast();

  /// Stream of notification tap events.
  Stream<NotificationResponse> get onNotificationTap =>
      _notificationTapController.stream;

  /// Initialize the notification service.
  Future<bool> initialize({NotificationTapCallback? onTap}) async {
    if (_isInitialized) return true;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      final initialized = await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          _notificationTapController.add(response);
          onTap?.call(response);

          if (response.payload != null && response.payload!.isNotEmpty) {
            _logger.i('Notification tapped. Routing to: ${response.payload}');
            _triggerDeepLinkRouting(response.payload!);
          }
        },
      );

      if (initialized ?? false) {
        if (!kIsWeb && Platform.isAndroid) {
          await _createAndroidChannels();
        }
        await _handleColdStartNotification();
        _isInitialized = true;
        _logger.i('LocalNotificationService initialized');
        return true;
      }
      return false;
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize notification service',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Request notification permissions (iOS/macOS).
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (Platform.isIOS || Platform.isMacOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await androidPlugin?.requestNotificationsPermission() ?? false;
    }
    return false;
  }

  /// Show a notification immediately.
  Future<void> show(LocalNotificationConfig config) async {
    await _ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      config.channelId,
      getChannelName(config.channelId),
      importance: config.importance,
      priority: config.priority,
      playSound: config.playSound,
      enableVibration: config.enableVibration,
      groupKey: config.groupKey,
    );

    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: config.playSound,
    );

    await _plugin.show(
      id: config.id,
      title: config.title,
      body: config.body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      ),
      payload: config.payload,
    );
  }

  /// Schedule a notification for a specific date/time.
  Future<void> schedule(
    LocalNotificationConfig config, {
    required DateTime scheduledDate,
  }) async {
    await _ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      config.channelId,
      getChannelName(config.channelId),
      importance: config.importance,
      priority: config.priority,
    );

    await _plugin.zonedSchedule(
      id: config.id,
      title: config.title,
      body: config.body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: config.payload,
    );
  }

  /// Cancel a notification by ID.
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  /// Cancel all notifications.
  Future<void> cancelAll() => _plugin.cancelAll();

  /// Get pending notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() =>
      _plugin.pendingNotificationRequests();

  /// Get active notifications (Android only).
  Future<List<ActiveNotification>> getActiveNotifications() async {
    if (!kIsWeb && Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.getActiveNotifications() ??
          [];
    }
    return [];
  }

  /// Get any pending deep link from cold start.
  String? consumePendingDeepLink() {
    final link = _pendingDeepLink;
    _pendingDeepLink = null;
    return link;
  }

  /// Dispose the service.
  void dispose() {
    _notificationTapController.close();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) await initialize();
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(defaultChannel);
    await androidPlugin?.createNotificationChannel(highPriorityChannel);
  }

  Future<void> _handleColdStartNotification() async {
    try {
      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final payload = launchDetails?.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) {
          _logger.i('App launched from notification: $payload');
          _pendingDeepLink = payload;
        }
      }
    } catch (e, stack) {
      _logger.e(
        'Error checking launch notification',
        error: e,
        stackTrace: stack,
      );
    }
  }

  void _triggerDeepLinkRouting(String path) {
    try {
      _logger.i('Deep link routing: $path');
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          _ref.read(appRouterProvider).go(path);
          _logger.i('Navigated to: $path');
        } catch (e, stack) {
          _logger.e('Navigation failed', error: e, stackTrace: stack);
        }
      });
    } catch (e, stack) {
      _logger.e('Deep link routing failed', error: e, stackTrace: stack);
    }
  }
}

/// Provider for [LocalNotificationService].
@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(Ref ref) {
  final service = LocalNotificationService(ref);
  ref.onDispose(service.dispose);
  return service;
}
