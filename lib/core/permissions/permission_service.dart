import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/feedback/feedback_service.dart';
import 'package:riverpod_go_router_boilerplate/core/permissions/permission_config.dart';

part 'permission_service.g.dart';

/// Service for handling runtime permissions with a clean API.
///
/// Abstracts the complexity of permission handling with:
/// - Status checking
/// - Request with rationale dialogs
/// - Automatic "Open Settings" prompts for permanently denied permissions
class PermissionService {
  /// Creates a [PermissionService] instance.
  new(this._ref);

  final Ref _ref;

  FeedbackService get _feedback => _ref.read(feedbackServiceProvider);

  /// Check the current status of a permission.
  Future<PermissionResult> check(Permission permission) async {
    final status = await permission.status;
    return status.toResult();
  }

  /// Check if a permission is granted.
  Future<bool> isGranted(Permission permission) async {
    return permission.isGranted;
  }

  /// Request a single permission.
  Future<bool> request(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Request a permission with a rationale dialog shown first.
  Future<bool> requestWithRationale(
    Permission permission, {
    required PermissionDialogConfig config,
  }) async {
    final currentStatus = await permission.status;

    if (currentStatus.isGranted) return true;

    if (currentStatus.isPermanentlyDenied) {
      return _handlePermanentlyDenied(config);
    }

    if (currentStatus.isDenied) {
      final shouldProceed = await _showRationaleDialog(config);
      if (!shouldProceed) return false;
    }

    final newStatus = await permission.request();

    if (newStatus.isPermanentlyDenied) {
      return _handlePermanentlyDenied(config);
    }

    return newStatus.isGranted;
  }

  /// Request multiple permissions at once.
  Future<Map<Permission, PermissionResult>> requestMultiple(
    List<Permission> permissions,
  ) async {
    final statuses = await permissions.request();
    return statuses.map(
      (permission, status) => MapEntry(permission, status.toResult()),
    );
  }

  /// Check if all specified permissions are granted.
  Future<bool> areAllGranted(List<Permission> permissions) async {
    for (final permission in permissions) {
      if (!await permission.isGranted) return false;
    }
    return true;
  }

  /// Open the app settings page.
  Future<bool> openSettings() => openAppSettings();

  Future<bool> _handlePermanentlyDenied(PermissionDialogConfig config) async {
    final shouldOpenSettings = await _feedback.showConfirmDialog(
      title: config.title,
      message:
          '${config.message}\n\n'
          'This permission was previously denied. '
          'Please enable it in Settings.',
      confirmLabel: config.settingsLabel,
      cancelLabel: config.cancelLabel,
    );

    if (shouldOpenSettings) await openSettings();
    return false;
  }

  Future<bool> _showRationaleDialog(PermissionDialogConfig config) async {
    return _feedback.showConfirmDialog(
      title: config.title,
      message: config.message,
      confirmLabel: config.confirmLabel,
      cancelLabel: config.cancelLabel,
    );
  }
}

/// Provider for [PermissionService].
@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) {
  return PermissionService(ref);
}
