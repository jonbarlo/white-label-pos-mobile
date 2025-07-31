import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'env_config.dart';

/// Provider for app information
final appInfoProvider = FutureProvider<AppInfo>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  
  return AppInfo(
    name: EnvConfig.appName,
    version: EnvConfig.appVersion,
    buildNumber: packageInfo.buildNumber,
    packageName: packageInfo.packageName,
  );
});

/// App information model
class AppInfo {
  final String name;
  final String version;
  final String buildNumber;
  final String packageName;

  const AppInfo({
    required this.name,
    required this.version,
    required this.buildNumber,
    required this.packageName,
  });

  /// Get full version string
  String get fullVersion => '$version+$buildNumber';

  /// Get display name (can be customized per white-label)
  String get displayName => name;
}