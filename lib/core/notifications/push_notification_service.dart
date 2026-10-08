import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'push_notification_service.g.dart';

/// Represents a push notification message.
class PushMessage {
  /// Creates a [PushMessage] instance.
  const new({this.title, this.body, this.data, this.imageUrl});

  /// Notification title.
  final String? title;

  /// Notification body text.
  final String? body;

  /// Additional data payload.
  final Map<String, dynamic>? data;

  /// Image URL for rich notifications.
  final String? imageUrl;

  @override
  String toString() => 'PushMessage(title: $title, body: $body, data: $data)';
}

/// Service for handling push notifications.
///
/// This is a stub implementation that prepares the infrastructure
/// without requiring Firebase configuration files.
///
/// **To enable Firebase Push Notifications:**
///
/// 1. Add Firebase to your project:
///    - Android: Add `google-services.json` to `android/app/`
///    - iOS: Add `GoogleService-Info.plist` to `ios/Runner/`
///
/// 2. Uncomment `firebase_messaging` in `pubspec.yaml`
///
/// 3. Enable the feature flag:
///    ```dart
///    EnvConfig.enableFeature('push_notifications');
///    ```
///
/// 4. Replace the stub implementation below with actual Firebase code
///
/// Example usage (once enabled):
/// ```dart
/// final pushService = ref.read(pushNotificationServiceProvider);
///
/// // Initialize and get FCM token
/// await pushService.initialize();
/// final token = await pushService.getToken();
///
/// // Listen for foreground messages
/// pushService.onMessage.listen((message) {
///   // Handle foreground notification
/// });
/// ```
class PushNotificationService {
  /// Creates a [PushNotificationService] instance.
  new(this._ref);

  final Ref _ref;

  AppLogger get _logger => _ref.read(loggerProvider);

  bool _isInitialized = false;
  String? _token;

  final _messageController = StreamController<PushMessage>.broadcast();
  final _tokenController = StreamController<String>.broadcast();

  /// Stream of incoming push messages (when app is in foreground).
  Stream<PushMessage> get onMessage => _messageController.stream;

  /// Stream of FCM token updates.
  Stream<String> get onTokenRefresh => _tokenController.stream;

  /// Whether push notifications are enabled.
  ///
  /// This is a stub that always returns false. In your implementation,
  /// check your remote config or feature flag service.
  bool get isEnabled {
    // TODO: Replace with your feature flag check
    // Example: return ref.read(remoteConfigProvider).getBool('push_enabled');
    return false;
  }

  /// Initialize the push notification service.
  ///
  /// This is safe to call even without Firebase configuration.
  /// It will simply log a message and return if not configured.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    if (!isEnabled) {
      _logger.i(
        'Push notifications are disabled. '
        'Enable via EnvConfig feature flag.',
      );
      return false;
    }

    try {
      // ════════════════════════════════════════════════════════════════════
      // STUB: Replace this section with actual Firebase Messaging code
      // ════════════════════════════════════════════════════════════════════
      //
      // Uncomment and use this code after adding Firebase:
      //
      // ```dart
      // import 'package:firebase_messaging/firebase_messaging.dart';
      //
      // final messaging = FirebaseMessaging.instance;
      //
      // // Request permission (iOS)
      // await messaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
      //
      // // Get FCM token
      // _token = await messaging.getToken();
      // _logger.i('FCM Token: $_token');
      //
      // // Listen for token refresh
      // messaging.onTokenRefresh.listen((token) {
      //   _token = token;
      //   _tokenController.add(token);
      //   // TODO: Send new token to your backend
      // });
      //
      // // Listen for foreground messages
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   _messageController.add(PushMessage(
      //     title: message.notification?.title,
      //     body: message.notification?.body,
      //     data: message.data,
      //     imageUrl: message.notification?.android?.imageUrl ??
      //               message.notification?.apple?.imageUrl,
      //   ));
      // });
      //
      // // SETUP INTERACTED MESSAGES (Deep Link Routing)
      // _setupInteractedMessage();
      // ```
      //
      // ════════════════════════════════════════════════════════════════════

      if (kDebugMode) {
        _logger.w(
          'PushNotificationService: Using stub implementation. '
          'Add Firebase configuration to enable real push notifications.',
        );
      }

      _isInitialized = true;
      return true;
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize PushNotificationService',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Handle notification taps when app is in background or terminated.
  ///
  /// This method is called during initialization to set up listeners
  /// for when users tap notifications.
  ///
  /// Uncomment in your actual Firebase implementation:
  /// ```dart
  /// Future<void> _setupInteractedMessage() async {
  ///   final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  ///   if (initialMessage != null) {
  ///     _handleMessage(initialMessage);
  ///   }
  ///
  ///   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  /// }
  /// ```

  /// Get the current FCM token.
  ///
  /// Returns null if not initialized or not configured.
  Future<String?> getToken() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _token;
  }

  /// Subscribe to a topic.
  Future<void> subscribeToTopic(String topic) async {
    if (!isEnabled) return;

    _logger.i('Subscribed to topic: $topic');
    // TODO: Implement with Firebase
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!isEnabled) return;

    _logger.i('Unsubscribed from topic: $topic');
    // TODO: Implement with Firebase
    // await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  /// Delete the FCM token (useful for logout).
  Future<void> deleteToken() async {
    if (!isEnabled) return;

    _token = null;
    _logger.i('FCM token deleted');
    // TODO: Implement with Firebase
    // await FirebaseMessaging.instance.deleteToken();
  }

  /// Dispose the service.
  void dispose() {
    _messageController.close();
    _tokenController.close();
  }
}

/// Provider for [PushNotificationService].
@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  final service = PushNotificationService(ref);
  ref.onDispose(service.dispose);
  return service;
}

// ════════════════════════════════════════════════════════════════════════════
// Background message handler (must be top-level function)
// ════════════════════════════════════════════════════════════════════════════
//
// Uncomment after adding Firebase:
//
// @pragma('vm:entry-point')
// Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//   // Initialize Firebase if needed
//   // await Firebase.initializeApp();
//
//   print('Handling background message: ${message.messageId}');
//
//   // Handle the message (e.g., update local database, show notification)
// }
