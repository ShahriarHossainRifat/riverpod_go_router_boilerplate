import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/config/remote_config_service.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

part 'app_version_service.g.dart';

/// Result of a version check against remote configuration.
enum VersionCheckResult {
  /// App version is up to date.
  upToDate,

  /// A newer version is available (optional update).
  updateAvailable,

  /// App version is below minimum required (force update).
  forceUpdateRequired,
}

/// Information about the current app version and update status.
class VersionInfo {
  /// Creates a [VersionInfo] instance.
  const new({
    required this.currentVersion,
    required this.currentBuildNumber,
    this.minimumVersion,
    this.latestVersion,
    this.checkResult = VersionCheckResult.upToDate,
    this.storeUrl,
  });

  /// The current app version (e.g., '1.0.0').
  final String currentVersion;

  /// The current build number.
  final String currentBuildNumber;

  /// Minimum required version from remote config.
  final String? minimumVersion;

  /// Latest available version from remote config.
  final String? latestVersion;

  /// Result of version comparison.
  final VersionCheckResult checkResult;

  /// URL to the app store for updates.
  final String? storeUrl;

  /// Whether a force update is required.
  bool get requiresForceUpdate =>
      checkResult == VersionCheckResult.forceUpdateRequired;

  /// Whether an optional update is available.
  bool get hasOptionalUpdate =>
      checkResult == VersionCheckResult.updateAvailable;
}

/// Service for checking app version against remote configuration.
///
/// Use this to implement force update and optional update prompts.
///
/// Example:
/// ```dart
/// final versionService = ref.read(appVersionServiceProvider);
/// final versionInfo = await versionService.checkVersion();
///
/// if (versionInfo.requiresForceUpdate) {
///   // Show force update dialog, block app usage
/// } else if (versionInfo.hasOptionalUpdate) {
///   // Show optional update prompt
/// }
/// ```
class AppVersionService {
  /// Creates an [AppVersionService] instance.
  new(this._ref);

  final Ref _ref;

  PackageInfo? _cachedPackageInfo;

  /// Get the current app's package info.
  Future<PackageInfo> getPackageInfo() async {
    _cachedPackageInfo ??= await PackageInfo.fromPlatform();
    return _cachedPackageInfo!;
  }

  /// Check the current app version against remote configuration.
  ///
  /// Returns [VersionInfo] with the check result.
  Future<Result<VersionInfo>> checkVersion() async {
    try {
      final packageInfo = await getPackageInfo();
      final remoteConfig = _ref.read(remoteConfigServiceProvider).currentConfig;

      final currentVersion = packageInfo.version;
      final minimumVersion = remoteConfig.minimumVersion;
      final forceUpdate = remoteConfig.forceUpdate;

      VersionCheckResult checkResult;

      if (forceUpdate && minimumVersion != null) {
        // Check if current version is below minimum
        if (_isVersionLower(currentVersion, minimumVersion)) {
          checkResult = .forceUpdateRequired;
        } else {
          checkResult = .upToDate;
        }
      } else if (minimumVersion != null) {
        // Optional update check
        if (_isVersionLower(currentVersion, minimumVersion)) {
          checkResult = .updateAvailable;
        } else {
          checkResult = .upToDate;
        }
      } else {
        checkResult = .upToDate;
      }

      return Success(
        VersionInfo(
          currentVersion: currentVersion,
          currentBuildNumber: packageInfo.buildNumber,
          minimumVersion: minimumVersion,
          checkResult: checkResult,
        ),
      );
    } catch (e, stack) {
      return Failure(
        UnexpectedException(
          message: 'Failed to check app version',
          originalError: e,
          stackTrace: stack,
        ),
      );
    }
  }

  /// Compare two semantic versions.
  /// Returns true if [version] is lower than [minimumVersion].
  bool _isVersionLower(String version, String minimumVersion) {
    final current = _parseVersion(version);
    final minimum = _parseVersion(minimumVersion);

    for (var i = 0; i < 3; i++) {
      if (current[i] < minimum[i]) return true;
      if (current[i] > minimum[i]) return false;
    }
    return false; // Versions are equal
  }

  /// Parse a version string into [major, minor, patch] integers.
  List<int> _parseVersion(String version) {
    final parts = version.split('.').map((p) {
      // Handle versions like "1.0.0+1" by stripping build metadata
      final numPart = p.split('+').first.split('-').first;
      return int.tryParse(numPart) ?? 0;
    }).toList();

    // Ensure we have exactly 3 parts
    while (parts.length < 3) {
      parts.add(0);
    }
    return parts.take(3).toList();
  }
}

/// Provider for [AppVersionService].
@Riverpod(keepAlive: true)
AppVersionService appVersionService(Ref ref) {
  return AppVersionService(ref);
}

/// Provider for the current [VersionInfo].
///
/// Watch this to reactively respond to version check results.
@riverpod
Future<VersionInfo> versionInfo(Ref ref) async {
  final service = ref.watch(appVersionServiceProvider);
  final result = await service.checkVersion();

  return result.fold(
    onSuccess: (info) => info,
    onFailure: (error) async {
      // Return default info on error
      final packageInfo = await service.getPackageInfo();
      return VersionInfo(
        currentVersion: packageInfo.version,
        currentBuildNumber: packageInfo.buildNumber,
      );
    },
  );
}

/// Provider that indicates if a force update is required.
@riverpod
bool requiresForceUpdate(Ref ref) {
  final versionAsync = ref.watch(versionInfoProvider);
  return switch (versionAsync) {
    AsyncData(:final value) => value.requiresForceUpdate,
    _ => false,
  };
}
