import 'package:shared_preferences/shared_preferences.dart';
import 'package:studex_flutter/models/study_session.dart';
import 'package:studex_flutter/models/achievement.dart';
import 'package:studex_flutter/models/quiz.dart';
import 'package:studex_flutter/models/video.dart';
import 'dart:convert';

class DatabaseService {
  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Study Sessions
  Future<void> insertStudySession(StudySession session) async {
    final prefs = await this.prefs;
    final sessions = await getStudySessions();
    sessions.insert(0, session);
    await prefs.setString('study_sessions', json.encode(sessions.map((s) => s.toMap()).toList()));
  }

  Future<void> updateStudySession(StudySession session) async {
    final prefs = await this.prefs;
    final sessions = await getStudySessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await prefs.setString('study_sessions', json.encode(sessions.map((s) => s.toMap()).toList()));
    }
  }

  Future<List<StudySession>> getStudySessions() async {
    final prefs = await this.prefs;
    final sessionsJson = prefs.getString('study_sessions');
    if (sessionsJson == null) return [];
    
    final List<dynamic> sessionsList = json.decode(sessionsJson);
    return sessionsList.map((map) => StudySession.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  Future<StudySession?> getStudySession(String id) async {
    final sessions = await getStudySessions();
    try {
      return sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteStudySession(String id) async {
    final prefs = await this.prefs;
    final sessions = await getStudySessions();
    sessions.removeWhere((session) => session.id == id);
    await prefs.setString('study_sessions', json.encode(sessions.map((s) => s.toMap()).toList()));
  }

  // Achievements
  Future<void> insertAchievement(Achievement achievement) async {
    final prefs = await this.prefs;
    final achievements = await getAchievements();
    achievements.add(achievement);
    await prefs.setString('achievements', json.encode(achievements.map((a) => a.toMap()).toList()));
  }

  Future<void> updateAchievement(Achievement achievement) async {
    final prefs = await this.prefs;
    final achievements = await getAchievements();
    final index = achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      achievements[index] = achievement;
      await prefs.setString('achievements', json.encode(achievements.map((a) => a.toMap()).toList()));
    }
  }

  Future<List<Achievement>> getAchievements() async {
    final prefs = await this.prefs;
    final achievementsJson = prefs.getString('achievements');
    if (achievementsJson == null) return [];
    
    final List<dynamic> achievementsList = json.decode(achievementsJson);
    return achievementsList.map((map) => Achievement.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  // Quizzes
  Future<void> insertQuiz(Quiz quiz) async {
    final prefs = await this.prefs;
    final quizzes = await getQuizzes();
    quizzes.insert(0, quiz);
    await prefs.setString('quizzes', json.encode(quizzes.map((q) => q.toMap()).toList()));
  }

  Future<void> updateQuiz(Quiz quiz) async {
    final prefs = await this.prefs;
    final quizzes = await getQuizzes();
    final index = quizzes.indexWhere((q) => q.id == quiz.id);
    if (index != -1) {
      quizzes[index] = quiz;
      await prefs.setString('quizzes', json.encode(quizzes.map((q) => q.toMap()).toList()));
    }
  }

  Future<List<Quiz>> getQuizzes() async {
    final prefs = await this.prefs;
    final quizzesJson = prefs.getString('quizzes');
    if (quizzesJson == null) return [];
    
    final List<dynamic> quizzesList = json.decode(quizzesJson);
    return quizzesList.map((map) => Quiz.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  Future<Quiz?> getQuiz(String id) async {
    final quizzes = await getQuizzes();
    try {
      return quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  // Videos
  Future<void> insertVideo(Video video) async {
    final prefs = await this.prefs;
    final videos = await getVideos();
    videos.insert(0, video);
    await prefs.setString('videos', json.encode(videos.map((v) => v.toMap()).toList()));
  }

  Future<void> updateVideo(Video video) async {
    final prefs = await this.prefs;
    final videos = await getVideos();
    final index = videos.indexWhere((v) => v.id == video.id);
    if (index != -1) {
      videos[index] = video;
      await prefs.setString('videos', json.encode(videos.map((v) => v.toMap()).toList()));
    }
  }

  Future<List<Video>> getVideos() async {
    final prefs = await this.prefs;
    final videosJson = prefs.getString('videos');
    if (videosJson == null) return [];
    
    final List<dynamic> videosList = json.decode(videosJson);
    return videosList.map((map) => Video.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  Future<List<Video>> getVideosByCategory(String category) async {
    final videos = await getVideos();
    return videos.where((video) => video.category == category).toList();
  }

  Future<List<Video>> getFavoriteVideos() async {
    final videos = await getVideos();
    return videos.where((video) => video.isFavorite).toList();
  }

  Future<void> deleteVideo(String videoId) async {
    final prefs = await this.prefs;
    final videos = await getVideos();
    videos.removeWhere((video) => video.id == videoId);
    await prefs.setString('videos', json.encode(videos.map((v) => v.toMap()).toList()));
  }

  // Playlists
  Future<void> insertPlaylist(Playlist playlist) async {
    final prefs = await this.prefs;
    final playlists = await getPlaylists();
    playlists.insert(0, playlist);
    await prefs.setString('playlists', json.encode(playlists.map((p) => p.toMap()).toList()));
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    final prefs = await this.prefs;
    final playlists = await getPlaylists();
    final index = playlists.indexWhere((p) => p.id == playlist.id);
    if (index != -1) {
      playlists[index] = playlist;
      await prefs.setString('playlists', json.encode(playlists.map((p) => p.toMap()).toList()));
    }
  }

  Future<List<Playlist>> getPlaylists() async {
    final prefs = await this.prefs;
    final playlistsJson = prefs.getString('playlists');
    if (playlistsJson == null) return [];
    
    final List<dynamic> playlistsList = json.decode(playlistsJson);
    return playlistsList.map((map) => Playlist.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  // Study Statistics
  Future<Map<String, dynamic>> getStudyStats() async {
    final sessions = await getStudySessions();
    final completedSessions = sessions.where((s) => s.isCompleted).toList();
    
    final totalTime = completedSessions.fold(0, (sum, session) => sum + session.actualDuration);
    final totalSessions = completedSessions.length;
    
    // Today's study time
    final today = DateTime.now();
    final todaySessions = completedSessions.where((session) {
      return session.startTime.year == today.year &&
             session.startTime.month == today.month &&
             session.startTime.day == today.day;
    });
    final todayTime = todaySessions.fold(0, (sum, session) => sum + session.actualDuration);
    
    // Weekly study time
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekSessions = completedSessions.where((session) {
      return session.startTime.isAfter(weekStart) && 
             session.startTime.isBefore(weekEnd);
    });
    final weekTime = weekSessions.fold(0, (sum, session) => sum + session.actualDuration);
    
    // Technique distribution
    final techniqueDistribution = <String, int>{};
    for (final session in completedSessions) {
      techniqueDistribution[session.technique] = (techniqueDistribution[session.technique] ?? 0) + 1;
    }
    
    return {
      'totalTime': totalTime,
      'totalSessions': totalSessions,
      'todayTime': todayTime,
      'weekTime': weekTime,
      'techniqueDistribution': techniqueDistribution,
    };
  }

  Future<void> close() async {
    // No-op for web
  }
}
