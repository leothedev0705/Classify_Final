import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/study_session_provider.dart';
import 'package:studex_flutter/providers/quiz_provider.dart';
import 'package:studex_flutter/providers/youtube_provider.dart';
import 'package:studex_flutter/widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh all data
              Provider.of<StudySessionProvider>(context, listen: false).initialize();
              Provider.of<QuizProvider>(context, listen: false).initialize();
              Provider.of<YouTubeProvider>(context, listen: false).initialize();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            const WelcomeBanner(),
            
            const SizedBox(height: 20),
            
            // Quick Stats
            const QuickStatsGrid(),
            
            const SizedBox(height: 20),
            
            // Weekly Progress Chart
            const WeeklyProgressChart(),
            
            const SizedBox(height: 20),
            
            // Recent Activity
            const RecentActivitySection(),
            
            const SizedBox(height: 20),
            
            // Upcoming Sessions
            const UpcomingSessionsSection(),
            
            const SizedBox(height: 20),
            
            // Quick Actions
            const QuickActionsSection(),
          ],
        ),
      ),
    );
  }
}
