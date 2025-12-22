import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Settings
  bool _isDarkMode = false;
  String _language = 'en';
  String _ambientSound = 'rain';
  double _soundVolume = 0.5;
  int _defaultStudyDuration = 25;
  int _defaultBreakDuration = 5;
  String _defaultStudyTechnique = 'pomodoro';
  bool _notificationsEnabled = true;
  bool _kioskModeEnabled = false;
  bool _phoneDetectionEnabled = true;
  bool _achievementNotifications = true;
  bool _studyReminders = true;
  int _reminderTime = 9; // 9 AM
  String _themeColor = 'blue';

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  String get ambientSound => _ambientSound;
  double get soundVolume => _soundVolume;
  int get defaultStudyDuration => _defaultStudyDuration;
  int get defaultBreakDuration => _defaultBreakDuration;
  String get defaultStudyTechnique => _defaultStudyTechnique;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get kioskModeEnabled => _kioskModeEnabled;
  bool get phoneDetectionEnabled => _phoneDetectionEnabled;
  bool get achievementNotifications => _achievementNotifications;
  bool get studyReminders => _studyReminders;
  int get reminderTime => _reminderTime;
  String get themeColor => _themeColor;
  bool get isInitialized => _isInitialized;

  // Initialize provider
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing settings: $e');
    }
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    if (_prefs == null) return;
    
    _isDarkMode = _prefs!.getBool('isDarkMode') ?? false;
    _language = _prefs!.getString('language') ?? 'en';
    _ambientSound = _prefs!.getString('ambientSound') ?? 'rain';
    _soundVolume = _prefs!.getDouble('soundVolume') ?? 0.5;
    _defaultStudyDuration = _prefs!.getInt('defaultStudyDuration') ?? 25;
    _defaultBreakDuration = _prefs!.getInt('defaultBreakDuration') ?? 5;
    _defaultStudyTechnique = _prefs!.getString('defaultStudyTechnique') ?? 'pomodoro';
    _notificationsEnabled = _prefs!.getBool('notificationsEnabled') ?? true;
    _kioskModeEnabled = _prefs!.getBool('kioskModeEnabled') ?? false;
    _phoneDetectionEnabled = _prefs!.getBool('phoneDetectionEnabled') ?? true;
    _achievementNotifications = _prefs!.getBool('achievementNotifications') ?? true;
    _studyReminders = _prefs!.getBool('studyReminders') ?? true;
    _reminderTime = _prefs!.getInt('reminderTime') ?? 9;
    _themeColor = _prefs!.getString('themeColor') ?? 'blue';
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    if (_prefs == null) return;
    
    await _prefs!.setBool('isDarkMode', _isDarkMode);
    await _prefs!.setString('language', _language);
    await _prefs!.setString('ambientSound', _ambientSound);
    await _prefs!.setDouble('soundVolume', _soundVolume);
    await _prefs!.setInt('defaultStudyDuration', _defaultStudyDuration);
    await _prefs!.setInt('defaultBreakDuration', _defaultBreakDuration);
    await _prefs!.setString('defaultStudyTechnique', _defaultStudyTechnique);
    await _prefs!.setBool('notificationsEnabled', _notificationsEnabled);
    await _prefs!.setBool('kioskModeEnabled', _kioskModeEnabled);
    await _prefs!.setBool('phoneDetectionEnabled', _phoneDetectionEnabled);
    await _prefs!.setBool('achievementNotifications', _achievementNotifications);
    await _prefs!.setBool('studyReminders', _studyReminders);
    await _prefs!.setInt('reminderTime', _reminderTime);
    await _prefs!.setString('themeColor', _themeColor);
  }

  // Theme settings
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setThemeColor(String value) async {
    _themeColor = value;
    await _saveSettings();
    notifyListeners();
  }

  // Study settings
  Future<void> setDefaultStudyDuration(int value) async {
    _defaultStudyDuration = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setDefaultBreakDuration(int value) async {
    _defaultBreakDuration = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setDefaultStudyTechnique(String value) async {
    _defaultStudyTechnique = value;
    await _saveSettings();
    notifyListeners();
  }

  // Sound settings
  Future<void> setAmbientSound(String value) async {
    _ambientSound = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setSoundVolume(double value) async {
    _soundVolume = value;
    await _saveSettings();
    notifyListeners();
  }

  // Notification settings
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setAchievementNotifications(bool value) async {
    _achievementNotifications = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setStudyReminders(bool value) async {
    _studyReminders = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setReminderTime(int value) async {
    _reminderTime = value;
    await _saveSettings();
    notifyListeners();
  }

  // Kiosk mode settings
  Future<void> setKioskModeEnabled(bool value) async {
    _kioskModeEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setPhoneDetectionEnabled(bool value) async {
    _phoneDetectionEnabled = value;
    await _saveSettings();
    notifyListeners();
  }

  // Reset all settings to default
  Future<void> resetToDefaults() async {
    _isDarkMode = false;
    _language = 'en';
    _ambientSound = 'rain';
    _soundVolume = 0.5;
    _defaultStudyDuration = 25;
    _defaultBreakDuration = 5;
    _defaultStudyTechnique = 'pomodoro';
    _notificationsEnabled = true;
    _kioskModeEnabled = false;
    _phoneDetectionEnabled = true;
    _achievementNotifications = true;
    _studyReminders = true;
    _reminderTime = 9;
    _themeColor = 'blue';
    
    await _saveSettings();
    notifyListeners();
  }

  // Export settings
  Map<String, dynamic> exportSettings() {
    return {
      'isDarkMode': _isDarkMode,
      'language': _language,
      'ambientSound': _ambientSound,
      'soundVolume': _soundVolume,
      'defaultStudyDuration': _defaultStudyDuration,
      'defaultBreakDuration': _defaultBreakDuration,
      'defaultStudyTechnique': _defaultStudyTechnique,
      'notificationsEnabled': _notificationsEnabled,
      'kioskModeEnabled': _kioskModeEnabled,
      'phoneDetectionEnabled': _phoneDetectionEnabled,
      'achievementNotifications': _achievementNotifications,
      'studyReminders': _studyReminders,
      'reminderTime': _reminderTime,
      'themeColor': _themeColor,
    };
  }

  // Import settings
  Future<void> importSettings(Map<String, dynamic> settings) async {
    _isDarkMode = settings['isDarkMode'] ?? _isDarkMode;
    _language = settings['language'] ?? _language;
    _ambientSound = settings['ambientSound'] ?? _ambientSound;
    _soundVolume = settings['soundVolume'] ?? _soundVolume;
    _defaultStudyDuration = settings['defaultStudyDuration'] ?? _defaultStudyDuration;
    _defaultBreakDuration = settings['defaultBreakDuration'] ?? _defaultBreakDuration;
    _defaultStudyTechnique = settings['defaultStudyTechnique'] ?? _defaultStudyTechnique;
    _notificationsEnabled = settings['notificationsEnabled'] ?? _notificationsEnabled;
    _kioskModeEnabled = settings['kioskModeEnabled'] ?? _kioskModeEnabled;
    _phoneDetectionEnabled = settings['phoneDetectionEnabled'] ?? _phoneDetectionEnabled;
    _achievementNotifications = settings['achievementNotifications'] ?? _achievementNotifications;
    _studyReminders = settings['studyReminders'] ?? _studyReminders;
    _reminderTime = settings['reminderTime'] ?? _reminderTime;
    _themeColor = settings['themeColor'] ?? _themeColor;
    
    await _saveSettings();
    notifyListeners();
  }

  // Get all settings as a map
  Map<String, dynamic> getAllSettings() {
    return {
      'theme': {
        'isDarkMode': _isDarkMode,
        'language': _language,
        'themeColor': _themeColor,
      },
      'study': {
        'defaultStudyDuration': _defaultStudyDuration,
        'defaultBreakDuration': _defaultBreakDuration,
        'defaultStudyTechnique': _defaultStudyTechnique,
      },
      'sound': {
        'ambientSound': _ambientSound,
        'soundVolume': _soundVolume,
      },
      'notifications': {
        'notificationsEnabled': _notificationsEnabled,
        'achievementNotifications': _achievementNotifications,
        'studyReminders': _studyReminders,
        'reminderTime': _reminderTime,
      },
      'kiosk': {
        'kioskModeEnabled': _kioskModeEnabled,
        'phoneDetectionEnabled': _phoneDetectionEnabled,
      },
    };
  }
}
