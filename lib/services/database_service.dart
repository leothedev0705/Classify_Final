import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:studex_flutter/models/study_session.dart';
import 'package:studex_flutter/models/achievement.dart';
import 'package:studex_flutter/models/quiz.dart';
import 'package:studex_flutter/models/video.dart';
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'studex.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // On web, use IndexedDB via sqflite_common_ffi_web or return a mock database
      // For now, throw an error indicating web is not supported for database operations
      throw UnsupportedError('Database operations are not fully supported on web platform. Please use a desktop or mobile app.');
    }
    
    // Initialize FFI for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final appDocDir = await getApplicationDocumentsDirectory();
      path = join(appDocDir.path, _databaseName);
    } else {
      final databasesPath = await getDatabasesPath();
      path = join(databasesPath, _databaseName);
    }

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Study Sessions Table
    await db.execute('''
      CREATE TABLE study_sessions (
        id TEXT PRIMARY KEY,
        technique TEXT NOT NULL,
        duration INTEGER NOT NULL,
        break_duration INTEGER NOT NULL,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        tasks TEXT,
        notes TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        ambient_sound TEXT,
        actual_duration INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Achievements Table
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        requirement TEXT NOT NULL,
        unlocked_at INTEGER,
        is_unlocked INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Quizzes Table
    await db.execute('''
      CREATE TABLE quizzes (
        id TEXT PRIMARY KEY,
        topic TEXT NOT NULL,
        subtopic TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        question_count INTEGER NOT NULL,
        questions TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        score INTEGER,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Videos Table
    await db.execute('''
      CREATE TABLE videos (
        id TEXT PRIMARY KEY,
        youtube_id TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        description TEXT,
        thumbnail_url TEXT,
        channel_name TEXT,
        duration INTEGER NOT NULL,
        category TEXT NOT NULL,
        tags TEXT,
        added_at INTEGER NOT NULL,
        notes TEXT,
        summary TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        playlist_id TEXT
      )
    ''');

    // Playlists Table
    await db.execute('''
      CREATE TABLE playlists (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        video_ids TEXT,
        created_at INTEGER NOT NULL,
        is_public INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tasks Table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        session_id TEXT,
        FOREIGN KEY (session_id) REFERENCES study_sessions (id)
      )
    ''');

    // Schedules Table
    await db.execute('''
      CREATE TABLE schedules (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        start_date INTEGER NOT NULL,
        end_date INTEGER NOT NULL,
        schedule_data TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Files Table
    await db.execute('''
      CREATE TABLE files (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        path TEXT NOT NULL,
        type TEXT NOT NULL,
        size INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        modified_at INTEGER NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // Study Sessions
  Future<void> insertStudySession(StudySession session) async {
    final db = await database;
    await db.insert('study_sessions', session.toMap());
  }

  Future<void> updateStudySession(StudySession session) async {
    final db = await database;
    await db.update(
      'study_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<List<StudySession>> getStudySessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'study_sessions',
      orderBy: 'start_time DESC',
    );
    return maps.map((map) => StudySession.fromMap(map)).toList();
  }

  Future<StudySession?> getStudySession(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'study_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return StudySession.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteStudySession(String id) async {
    final db = await database;
    await db.delete(
      'study_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Achievements
  Future<void> insertAchievement(Achievement achievement) async {
    final db = await database;
    await db.insert('achievements', achievement.toMap());
  }

  Future<void> updateAchievement(Achievement achievement) async {
    final db = await database;
    await db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  Future<List<Achievement>> getAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return maps.map((map) => Achievement.fromMap(map)).toList();
  }

  // Quizzes
  Future<void> insertQuiz(Quiz quiz) async {
    final db = await database;
    await db.insert('quizzes', quiz.toMap());
  }

  Future<void> updateQuiz(Quiz quiz) async {
    final db = await database;
    await db.update(
      'quizzes',
      quiz.toMap(),
      where: 'id = ?',
      whereArgs: [quiz.id],
    );
  }

  Future<List<Quiz>> getQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quizzes',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Quiz.fromMap(map)).toList();
  }

  Future<Quiz?> getQuiz(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quizzes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Quiz.fromMap(maps.first);
    }
    return null;
  }

  // Videos
  Future<void> insertVideo(Video video) async {
    final db = await database;
    await db.insert('videos', video.toMap());
  }

  Future<void> updateVideo(Video video) async {
    final db = await database;
    await db.update(
      'videos',
      video.toMap(),
      where: 'id = ?',
      whereArgs: [video.id],
    );
  }

  Future<List<Video>> getVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'videos',
      orderBy: 'added_at DESC',
    );
    return maps.map((map) => Video.fromMap(map)).toList();
  }

  Future<List<Video>> getVideosByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'videos',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'added_at DESC',
    );
    return maps.map((map) => Video.fromMap(map)).toList();
  }

  Future<List<Video>> getFavoriteVideos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'videos',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'added_at DESC',
    );
    return maps.map((map) => Video.fromMap(map)).toList();
  }

  Future<void> deleteVideo(String videoId) async {
    final db = await database;
    await db.delete(
      'videos',
      where: 'id = ?',
      whereArgs: [videoId],
    );
  }

  // Playlists
  Future<void> insertPlaylist(Playlist playlist) async {
    final db = await database;
    await db.insert('playlists', playlist.toMap());
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await database;
    await db.update(
      'playlists',
      playlist.toMap(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'playlists',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Playlist.fromMap(map)).toList();
  }

  // Study Statistics
  Future<Map<String, dynamic>> getStudyStats() async {
    final db = await database;
    
    // Total study time
    final totalTimeResult = await db.rawQuery('''
      SELECT SUM(actual_duration) as total_time FROM study_sessions 
      WHERE is_completed = 1
    ''');
    final totalTime = totalTimeResult.first['total_time'] as int? ?? 0;

    // Total sessions
    final sessionsResult = await db.rawQuery('''
      SELECT COUNT(*) as total_sessions FROM study_sessions 
      WHERE is_completed = 1
    ''');
    final totalSessions = sessionsResult.first['total_sessions'] as int? ?? 0;

    // Today's study time
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    final todayTimeResult = await db.rawQuery('''
      SELECT SUM(actual_duration) as today_time FROM study_sessions 
      WHERE is_completed = 1 AND start_time >= ? AND start_time < ?
    ''', [todayStart.millisecondsSinceEpoch, todayEnd.millisecondsSinceEpoch]);
    final todayTime = todayTimeResult.first['today_time'] as int? ?? 0;

    // Weekly study time
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    
    final weekTimeResult = await db.rawQuery('''
      SELECT SUM(actual_duration) as week_time FROM study_sessions 
      WHERE is_completed = 1 AND start_time >= ? AND start_time < ?
    ''', [weekStart.millisecondsSinceEpoch, weekEnd.millisecondsSinceEpoch]);
    final weekTime = weekTimeResult.first['week_time'] as int? ?? 0;

    // Technique distribution
    final techniqueResult = await db.rawQuery('''
      SELECT technique, COUNT(*) as count FROM study_sessions 
      WHERE is_completed = 1 GROUP BY technique
    ''');
    final techniqueDistribution = Map<String, int>.fromEntries(
      techniqueResult.map((row) => MapEntry(row['technique'] as String, row['count'] as int))
    );

    return {
      'totalTime': totalTime,
      'totalSessions': totalSessions,
      'todayTime': todayTime,
      'weekTime': weekTime,
      'techniqueDistribution': techniqueDistribution,
    };
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
