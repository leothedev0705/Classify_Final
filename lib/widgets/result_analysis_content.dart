import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/study_session_provider.dart';
import '../models/study_session.dart';
import '../themes/app_theme.dart';
import 'TopMostInfoBox/top_most_info_box.dart';

class ResultAnalysisContent extends StatefulWidget {
  @override
  _ResultAnalysisContentState createState() => _ResultAnalysisContentState();
}

class _ResultAnalysisContentState extends State<ResultAnalysisContent> {
  String _getSectionDisplayName(String section) {
    switch (section) {
      case 'dashboard':
        return 'Dashboard';
      case 'study-session':
        return 'Study Session';
      case 'edutube':
        return 'EduTube';
      case 'edubot':
        return 'EduBot';
      case 'quizzes':
        return 'Quizzes';
      case 'schedule':
        return 'Schedule';
      case 'office-suite':
        return 'Office Suite';
      case 'file-explorer':
        return 'File Explorer';
      case 'result-analysis':
        return 'Result Analysis';
      default:
        return section;
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  String _getTechniqueDisplayName(String technique) {
    switch (technique) {
      case 'pomodoro':
        return 'Pomodoro Technique';
      case 'flow':
        return 'Flow Method';
      case 'timeblocking':
        return 'Time Blocking';
      case 'deepfocus':
        return 'Deep Focus';
      default:
        return technique;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopMostInfoBox(
            title: 'Analyze your progress',
            subtitle: 'Turn data into insights and improve faster.',
            imageAsset: 'assets/images/home-girl.png',
          ),
          const SizedBox(height: 24),
          Consumer<StudySessionProvider>(
            builder: (context, studyProvider, child) {
              final sessions = studyProvider.completedSessions;
              
              if (sessions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No sessions yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete a study session to see detailed analytics here',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study Sessions (${sessions.length})',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF353E6C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...sessions.map((session) => _buildSessionCard(session)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(StudySession session) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    final startTimeStr = dateFormat.format(session.startTime);
    final endTimeStr = session.endTime != null 
        ? dateFormat.format(session.endTime!)
        : 'Ongoing';
    
    // Calculate total time spent in all sections
    final totalSectionTime = session.sectionTimeSpent.values.fold(0, (sum, time) => sum + time);
    
    // Sort sections by time spent (descending)
    final sortedSections = session.sectionTimeSpent.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF353E6C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getTechniqueDisplayName(session.technique),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF353E6C),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${session.actualDuration} min',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$startTimeStr - $endTimeStr',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (sortedSections.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${sortedSections.length} sections tracked',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        children: [
          if (sortedSections.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No section data available',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Time Breakdown by Section',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
            const SizedBox(height: 16),
            ...sortedSections.map((entry) {
              final sectionName = _getSectionDisplayName(entry.key);
              final timeSpent = entry.value;
              final percentage = totalSectionTime > 0 
                  ? (timeSpent / totalSectionTime * 100)
                  : 0.0;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sectionName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF353E6C),
                            ),
                          ),
                        ),
                        Text(
                          _formatDuration(timeSpent),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF21A366),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF21A366)),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF353E6C).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tracked Time',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF353E6C),
                    ),
                  ),
                  Text(
                    _formatDuration(totalSectionTime),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF353E6C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
