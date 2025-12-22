import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/settings_provider.dart';
import 'package:studex_flutter/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          if (!settingsProvider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Settings
                _buildSettingsSection(
                  'Theme',
                  [
                    _buildSwitchTile(
                    'Dark Mode',
                    'Enable dark theme',
                    settingsProvider.isDarkMode,
                    (value) => settingsProvider.setDarkMode(value),
                    Icons.dark_mode,
                  ),
                  _buildDropdownTile(
                    'Language',
                    'Select app language',
                    settingsProvider.language,
                    (value) => settingsProvider.setLanguage(value),
                    Icons.language,
                    const {
                      'en': 'English',
                      'es': 'Spanish',
                      'fr': 'French',
                      'de': 'German',
                      'hi': 'Hindi',
                    },
                  ),
                  _buildDropdownTile(
                    'Theme Color',
                    'Choose your preferred color',
                    settingsProvider.themeColor,
                    (value) => settingsProvider.setThemeColor(value),
                    Icons.palette,
                    const {
                      'blue': 'Blue',
                      'green': 'Green',
                      'purple': 'Purple',
                      'orange': 'Orange',
                      'red': 'Red',
                    },
                  ),
                ]),
                
                const SizedBox(height: 24),
                
                // Study Settings
                _buildSettingsSection(
                  'Study',
                  [
                    _buildSliderTile(
                      'Default Study Duration',
                      '${settingsProvider.defaultStudyDuration} minutes',
                      settingsProvider.defaultStudyDuration.toDouble(),
                      5,
                      180,
                      (value) => settingsProvider.setDefaultStudyDuration(value.round()),
                      Icons.timer,
                    ),
                    _buildSliderTile(
                      'Default Break Duration',
                      '${settingsProvider.defaultBreakDuration} minutes',
                      settingsProvider.defaultBreakDuration.toDouble(),
                      1,
                      60,
                      (value) => settingsProvider.setDefaultBreakDuration(value.round()),
                      Icons.coffee,
                    ),
                    _buildDropdownTile(
                      'Default Study Technique',
                      'Choose your preferred study method',
                      settingsProvider.defaultStudyTechnique,
                      (value) => settingsProvider.setDefaultStudyTechnique(value),
                      Icons.school,
                      AppConstants.studyTechniques.map((key, value) => MapEntry(key, value['name'])),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Sound Settings
                _buildSettingsSection(
                  'Sound',
                  [
                    _buildDropdownTile(
                      'Ambient Sound',
                      'Choose background sound for study sessions',
                      settingsProvider.ambientSound,
                      (value) => settingsProvider.setAmbientSound(value),
                      Icons.volume_up,
                      AppConstants.ambientSounds,
                    ),
                    _buildSliderTile(
                      'Sound Volume',
                      '${(settingsProvider.soundVolume * 100).round()}%',
                      settingsProvider.soundVolume,
                      0.0,
                      1.0,
                      (value) => settingsProvider.setSoundVolume(value),
                      Icons.volume_up,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Notification Settings
                _buildSettingsSection(
                  'Notifications',
                  [
                    _buildSwitchTile(
                      'Enable Notifications',
                      'Receive study reminders and updates',
                      settingsProvider.notificationsEnabled,
                      (value) => settingsProvider.setNotificationsEnabled(value),
                      Icons.notifications,
                    ),
                    _buildSwitchTile(
                      'Achievement Notifications',
                      'Get notified when you earn achievements',
                      settingsProvider.achievementNotifications,
                      (value) => settingsProvider.setAchievementNotifications(value),
                      Icons.emoji_events,
                    ),
                    _buildSwitchTile(
                      'Study Reminders',
                      'Receive daily study reminders',
                      settingsProvider.studyReminders,
                      (value) => settingsProvider.setStudyReminders(value),
                      Icons.schedule,
                    ),
                    _buildSliderTile(
                      'Reminder Time',
                      '${settingsProvider.reminderTime}:00',
                      settingsProvider.reminderTime.toDouble(),
                      6,
                      22,
                      (value) => settingsProvider.setReminderTime(value.round()),
                      Icons.access_time,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Kiosk Mode Settings
                _buildSettingsSection(
                  'Kiosk Mode',
                  [
                    _buildSwitchTile(
                      'Enable Kiosk Mode',
                      'Prevent access to other apps during study',
                      settingsProvider.kioskModeEnabled,
                      (value) => settingsProvider.setKioskModeEnabled(value),
                      Icons.lock,
                    ),
                    _buildSwitchTile(
                      'Phone Detection',
                      'Detect when phone is picked up during study',
                      settingsProvider.phoneDetectionEnabled,
                      (value) => settingsProvider.setPhoneDetectionEnabled(value),
                      Icons.phone_android,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Data Management
                _buildSettingsSection(
                  'Data Management',
                  [
                    _buildActionTile(
                      'Export Data',
                      'Export your study data and settings',
                      () => _showExportDialog(settingsProvider),
                      Icons.download,
                    ),
                    _buildActionTile(
                      'Import Data',
                      'Import study data and settings',
                      () => _showImportDialog(settingsProvider),
                      Icons.upload,
                    ),
                    _buildActionTile(
                      'Reset to Defaults',
                      'Reset all settings to default values',
                      () => _showResetDialog(settingsProvider),
                      Icons.restore,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // App Information
                _buildSettingsSection(
                  'App Information',
                  [
                    _buildInfoTile(
                      'Version',
                      '1.0.0',
                      Icons.info,
                    ),
                    _buildInfoTile(
                      'Build',
                      '1.0.0+1',
                      Icons.build,
                    ),
                    _buildActionTile(
                      'About',
                      'Learn more about StuDex',
                      () => _showAboutDialog(),
                      Icons.help,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    Function(String) onChanged,
    IconData icon,
    Map<String, String> items,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (newValue) => onChanged(newValue!),
        items: items.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    VoidCallback onTap,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showExportDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('This will export your study data and settings to a file.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data exported successfully')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text('This will import study data and settings from a file.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data imported successfully')),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('This will reset all settings to their default values. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              settingsProvider.resetToDefaults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About StuDex'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('StuDex - Study Session Manager'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A comprehensive study productivity app with kiosk mode, multiple study techniques, AI-powered features, and educational content management.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Multiple study techniques'),
            Text('• AI-powered quiz generator'),
            Text('• YouTube integration'),
            Text('• Achievement system'),
            Text('• Office suite integration'),
            Text('• AI schedule generator'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
