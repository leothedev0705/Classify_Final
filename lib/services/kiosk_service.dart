import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class KioskService {
  static const MethodChannel _channel = MethodChannel('com.studex/kiosk');

  /// Enable true kiosk mode - blocks all system shortcuts and app switching
  static Future<bool> enableKioskMode() async {
    if (!Platform.isWindows) {
      // For non-Windows platforms, return true (handled by SystemChrome)
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>('enableKioskMode');
      return result ?? false;
    } catch (e) {
      print('Error enabling kiosk mode: $e');
      return false;
    }
  }

  /// Disable kiosk mode - restore normal system behavior
  static Future<bool> disableKioskMode() async {
    if (!Platform.isWindows) {
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>('disableKioskMode');
      return result ?? false;
    } catch (e) {
      print('Error disabling kiosk mode: $e');
      return false;
    }
  }

  /// Block notifications during kiosk mode
  static Future<bool> blockNotifications(bool block) async {
    if (!Platform.isWindows) {
      return true;
    }
    
    try {
      final result = await _channel.invokeMethod<bool>('blockNotifications', {'block': block});
      return result ?? false;
    } catch (e) {
      print('Error blocking notifications: $e');
      return false;
    }
  }
}

