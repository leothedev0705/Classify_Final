import 'package:flutter/material.dart';
import 'package:studex_flutter/screens/dashboard_screen.dart';
import 'package:studex_flutter/screens/study_session_screen.dart';
import 'package:studex_flutter/screens/youtube_screen.dart';
import 'package:studex_flutter/screens/quiz_screen.dart';
import 'package:studex_flutter/screens/schedule_screen.dart';
import 'package:studex_flutter/screens/office_suite_screen.dart';
import 'package:studex_flutter/screens/file_explorer_screen.dart';
import 'package:studex_flutter/screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const StudySessionScreen(),
    const YouTubeScreen(),
    const QuizScreen(),
    const ScheduleScreen(),
    const OfficeSuiteScreen(),
    const FileExplorerScreen(),
    const SettingsScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Dashboard',
      screen: const DashboardScreen(),
    ),
    NavigationItem(
      icon: Icons.timer,
      label: 'Study Session',
      screen: const StudySessionScreen(),
    ),
    NavigationItem(
      icon: Icons.video_library,
      label: 'YouTube',
      screen: const YouTubeScreen(),
    ),
    NavigationItem(
      icon: Icons.quiz,
      label: 'Quiz',
      screen: const QuizScreen(),
    ),
    NavigationItem(
      icon: Icons.calendar_today,
      label: 'Schedule',
      screen: const ScheduleScreen(),
    ),
    NavigationItem(
      icon: Icons.description,
      label: 'Office Suite',
      screen: const OfficeSuiteScreen(),
    ),
    NavigationItem(
      icon: Icons.folder,
      label: 'Files',
      screen: const FileExplorerScreen(),
    ),
    NavigationItem(
      icon: Icons.settings,
      label: 'Settings',
      screen: const SettingsScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          items: _navigationItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
