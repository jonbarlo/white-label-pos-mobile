import 'dart:io';
import 'dart:convert';

/// Script to generate platform-specific app configurations
/// This allows for dynamic app naming based on environment variables
void main(List<String> args) async {
  String appName = 'POS Mobile'; // Default fallback
  
  // Try to read from .env file first
  try {
    final envFile = File('.env');
    if (await envFile.exists()) {
      final content = await envFile.readAsString();
      final lines = content.split('\n');
      
      for (final line in lines) {
        if (line.trim().startsWith('APP_NAME=')) {
          appName = line.split('=')[1].trim();
          // Remove quotes if present
          if (appName.startsWith('"') && appName.endsWith('"')) {
            appName = appName.substring(1, appName.length - 1);
          }
          break;
        }
      }
    }
  } catch (e) {
    print('⚠️  Error reading .env file: $e');
  }
  
  // Fallback to system environment variable
  if (appName == 'POS Mobile') {
    appName = Platform.environment['APP_NAME'] ?? 'POS Mobile';
  }
  
  print('🔧 Generating app configuration with name: $appName');
  
  // Update Android manifest
  await updateAndroidManifest(appName);
  
  // Update iOS Info.plist
  await updateIOSInfoPlist(appName);
  
  print('✅ App configuration updated successfully!');
}

Future<void> updateAndroidManifest(String appName) async {
  final manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final file = File(manifestPath);
  
  if (!await file.exists()) {
    print('⚠️  Android manifest not found at $manifestPath');
    return;
  }
  
  String content = await file.readAsString();
  content = content.replaceAll(
    RegExp(r'android:label="[^"]*"'),
    'android:label="$appName"'
  );
  
  await file.writeAsString(content);
  print('✅ Updated Android manifest');
}

Future<void> updateIOSInfoPlist(String appName) async {
  final plistPath = 'ios/Runner/Info.plist';
  final file = File(plistPath);
  
  if (!await file.exists()) {
    print('⚠️  iOS Info.plist not found at $plistPath');
    return;
  }
  
  String content = await file.readAsString();
  content = content.replaceAll(
    RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>'),
    '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>'
  );
  
  await file.writeAsString(content);
  print('✅ Updated iOS Info.plist');
}