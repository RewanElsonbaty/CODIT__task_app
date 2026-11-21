import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Service for getting device information
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo;

  DeviceInfoService(this._deviceInfo);

  /// Get unique device ID
  /// 
  /// This generates a consistent device identifier that can be used
  /// for device verification and session management.
  Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Use Android ID as device identifier
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // Use identifierForVendor as device identifier
        return iosInfo.identifierForVendor ?? 'unknown_ios';
      } else {
        return 'unknown_platform';
      }
    } catch (e) {
      debugPrint('[DeviceInfo] Error getting device ID: $e');
      return 'error_device_id';
    }
  }

  /// Get device name/model
  Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name} (${iosInfo.model})';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      debugPrint('[DeviceInfo] Error getting device name: $e');
      return 'Unknown Device';
    }
  }

  /// Get device type (Android/iOS)
  String getDeviceType() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }

  /// Get OS version
  Future<String> getOsVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      } else {
        return 'Unknown OS';
      }
    } catch (e) {
      debugPrint('[DeviceInfo] Error getting OS version: $e');
      return 'Unknown OS';
    }
  }

  /// Get complete device info as a map
  Future<Map<String, String>> getDeviceInfo() async {
    return {
      'device_id': await getDeviceId(),
      'device_name': await getDeviceName(),
      'device_type': getDeviceType(),
      'os_version': await getOsVersion(),
    };
  }

  /// Get masked device ID for display (shows only last 3 characters)
  Future<String> getMaskedDeviceId() async {
    final deviceId = await getDeviceId();
    if (deviceId.length > 3) {
      return 'device_***${deviceId.substring(deviceId.length - 3)}';
    }
    return 'device_***';
  }
}
