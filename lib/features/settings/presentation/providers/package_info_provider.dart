import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_provider.g.dart';

/// Provider for package info.
@Riverpod(keepAlive: true)
Future<PackageInfo> packageInfo(Ref ref) async {
  return PackageInfo.fromPlatform();
}
