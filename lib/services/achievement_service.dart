import 'package:studex_flutter/models/achievement.dart';
import 'package:studex_flutter/models/study_session.dart';
import 'package:studex_flutter/constants/app_constants.dart';

class AchievementService {
  // Check for new achievements based on study sessions
  Future<List<Achievement>> checkAchievements(List<StudySession> sessions) async {
    final List<Achievement> newAchievements = [];
    
    for (final achievementData in AppConstants.achievements.values) {
      final achievement = Achievement(
        name: achievementData['name'],
        description: achievementData['description'],
        icon: achievementData['icon'],
        requirement: achievementData['requirement'],
      );
      
      if (_checkAchievementRequirement(achievement, sessions)) {
        final unlockedAchievement = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        newAchievements.add(unlockedAchievement);
      }
    }
    
    return newAchievements;
  }

  // Check if achievement requirement is met
  bool _checkAchievementRequirement(Achievement achievement, List<StudySession> sessions) {
    final requirement = achievement.requirement;
    final type = requirement['type'] as String;
    
    switch (type) {
      case 'sessions':
        final requiredCount = requirement['count'] as int;
        final completedSessions = sessions.where((s) => s.isCompleted).length;
        return completedSessions >= requiredCount;
        
      case 'total_time':
        final requiredMinutes = requirement['minutes'] as int;
        final totalTime = sessions.fold(0, (sum, session) => sum + session.actualDuration);
        return totalTime >= requiredMinutes;
        
      case 'technique_sessions':
        final technique = requirement['technique'] as String;
        final requiredCount = requirement['count'] as int;
        final techniqueSessions = sessions.where((s) => 
          s.isCompleted && s.technique == technique).length;
        return techniqueSessions >= requiredCount;
        
      case 'time_of_day':
        final requiredHour = requirement['hour'] as int;
        final nightSessions = sessions.where((s) => 
          s.isCompleted && s.startTime.hour >= requiredHour).length;
        return nightSessions > 0;
        
      case 'tasks_completed':
        final requiredCount = requirement['count'] as int;
        final totalTasks = sessions.fold(0, (sum, session) => sum + session.tasks.length);
        return totalTasks >= requiredCount;
        
      default:
        return false;
    }
  }

  // Get achievement progress
  Map<String, dynamic> getAchievementProgress(Achievement achievement, List<StudySession> sessions) {
    final requirement = achievement.requirement;
    final type = requirement['type'] as String;
    
    switch (type) {
      case 'sessions':
        final requiredCount = requirement['count'] as int;
        final completedSessions = sessions.where((s) => s.isCompleted).length;
        return {
          'current': completedSessions,
          'required': requiredCount,
          'progress': (completedSessions / requiredCount).clamp(0.0, 1.0),
        };
        
      case 'total_time':
        final requiredMinutes = requirement['minutes'] as int;
        final totalTime = sessions.fold(0, (sum, session) => sum + session.actualDuration);
        return {
          'current': totalTime,
          'required': requiredMinutes,
          'progress': (totalTime / requiredMinutes).clamp(0.0, 1.0),
        };
        
      case 'technique_sessions':
        final technique = requirement['technique'] as String;
        final requiredCount = requirement['count'] as int;
        final techniqueSessions = sessions.where((s) => 
          s.isCompleted && s.technique == technique).length;
        return {
          'current': techniqueSessions,
          'required': requiredCount,
          'progress': (techniqueSessions / requiredCount).clamp(0.0, 1.0),
        };
        
      case 'time_of_day':
        final requiredHour = requirement['hour'] as int;
        final nightSessions = sessions.where((s) => 
          s.isCompleted && s.startTime.hour >= requiredHour).length;
        return {
          'current': nightSessions,
          'required': 1,
          'progress': nightSessions > 0 ? 1.0 : 0.0,
        };
        
      case 'tasks_completed':
        final requiredCount = requirement['count'] as int;
        final totalTasks = sessions.fold(0, (sum, session) => sum + session.tasks.length);
        return {
          'current': totalTasks,
          'required': requiredCount,
          'progress': (totalTasks / requiredCount).clamp(0.0, 1.0),
        };
        
      default:
        return {
          'current': 0,
          'required': 1,
          'progress': 0.0,
        };
    }
  }

  // Get all achievements with progress
  List<Map<String, dynamic>> getAllAchievementsWithProgress(List<StudySession> sessions) {
    final List<Map<String, dynamic>> achievementsWithProgress = [];
    
    for (final achievementData in AppConstants.achievements.values) {
      final achievement = Achievement(
        name: achievementData['name'],
        description: achievementData['description'],
        icon: achievementData['icon'],
        requirement: achievementData['requirement'],
      );
      
      final progress = getAchievementProgress(achievement, sessions);
      final isUnlocked = _checkAchievementRequirement(achievement, sessions);
      
      achievementsWithProgress.add({
        'achievement': achievement,
        'progress': progress,
        'isUnlocked': isUnlocked,
      });
    }
    
    return achievementsWithProgress;
  }
}
