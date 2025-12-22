import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';

class LeftNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, AuthProvider>(
      builder: (context, appProvider, authProvider, child) {
        return Container(
          width: 280,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5B68DF),
                Color(0xFF4A56C8),
                Color(0xFF3A46B5),
              ],
            ),
          ),
          child: Column(
            children: [
              // StuDex Logo
              _buildLogo(),
              SizedBox(height: 20),
              // Navigation Links
              Expanded(
                child: _buildNavLinks(appProvider),
              ),
              // Sign Out Button
              _buildSignOutButton(authProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Row(
        children: [
          SizedBox(width: 12),
          Text(
            'StuDex',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLinks(AppProvider appProvider) {
    final navItems = [
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'section': 'dashboard'},
      {'icon': Icons.access_time, 'label': 'Study Session', 'section': 'study-session'},
      {'icon': Icons.play_circle_outline, 'label': 'Youtube', 'section': 'youtube'},
      {'icon': Icons.bar_chart, 'label': 'Result Analysis', 'section': 'result-analysis'},
      {'icon': Icons.folder_open, 'label': 'File Explorer', 'section': 'file-explorer'},
      {'icon': Icons.calendar_today, 'label': 'Schedule', 'section': 'schedule'},
      {'icon': Icons.quiz, 'label': 'Quizzes', 'section': 'quizzes'},
      {'icon': Icons.build, 'label': 'Tools', 'section': 'office-suite'},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon sidebar
        Container(
          width: 60,
          child: Column(
            children: navItems.map((item) {
              final isActive = appProvider.currentSection == item['section'];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Icon(
                  item['icon'] as IconData,
                  size: 24,
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                ),
              );
            }).toList(),
          ),
        ),
        // Navigation items
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              children: navItems.map((item) {
                final isActive = appProvider.currentSection == item['section'];
                return Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => appProvider.setCurrentSection(item['section'] as String),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: isActive ? Color(0xFF3A46B5) : Colors.white,
                                fontSize: 15,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(AuthProvider authProvider) {
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon on the left sidebar
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Icon(
                Icons.logout,
                size: 24,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            // Sign Out button
            Expanded(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _showLogoutDialog(context, authProvider),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authProvider.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
