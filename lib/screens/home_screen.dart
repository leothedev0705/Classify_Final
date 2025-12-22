import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/study_session_provider.dart';
import '../widgets/studex_sidebar.dart';
import '../widgets/top_bar.dart';
import '../widgets/dashboard_content.dart';
import '../widgets/study_session_content.dart';
import '../widgets/youtube_content.dart';
import '../widgets/edubot_content.dart';
import '../widgets/quiz_content.dart';
import '../widgets/schedule_content.dart';
import '../widgets/office_suite_content.dart';
import '../widgets/file_explorer_content.dart';
import '../widgets/result_analysis_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Must match section order in the sidebar
  final List<String> sectionOrder = [
    'dashboard',
    'study-session',
    'edutube',
    'edubot',
    'result-analysis',
    'file-explorer',
    'schedule',
    'quizzes',
    'office-suite',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          body: Row(
            children: [
              // StuDex Sidebar
              StuDexSidebar(
                onItemSelected: (index) {
                  // set section string in provider
                  if (index >= 0 && index < sectionOrder.length) {
                    final newSection = sectionOrder[index];
                    appProvider.setCurrentSection(newSection);
                    
                    // Track section change for study session
                    final studyProvider = Provider.of<StudySessionProvider>(context, listen: false);
                    studyProvider.onSectionChanged(newSection);
                  }
                },
              ),
              // Main Content Area
              Expanded(
                child: Container(
                  color: Color(0xFFEDEEF2),
                  child: Column(
                    children: [
                      // Top Bar
                      TopBar(),
                      // Content Sections
                      Expanded(
                        child: _buildContentSection(appProvider.currentSection),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection(String currentSection) {
    // Track section change when content changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studyProvider = Provider.of<StudySessionProvider>(context, listen: false);
      studyProvider.onSectionChanged(currentSection);
    });
    
    switch (currentSection) {
      case 'dashboard':
        return DashboardContent();
      case 'study-session':
        return StudySessionContent();
      case 'edutube':
        return YouTubeContent();
      case 'edubot':
        return EduBotContent();
      case 'quizzes':
        return QuizContent();
      case 'schedule':
        return ScheduleContent();
      case 'office-suite':
        return OfficeSuiteContent();
      case 'file-explorer':
        return FileExplorerContent();
      case 'result-analysis':
        return ResultAnalysisContent();
      default:
        return DashboardContent();
    }
  }
}
