class AppConstants {
  // App Information
  static const String appName = 'StuDex';
  static const String appVersion = '1.0.0';
  
  // Study Techniques
  static const Map<String, Map<String, dynamic>> studyTechniques = {
    'pomodoro': {
      'name': 'Pomodoro Technique',
      'duration': 25,
      'breakDuration': 5,
      'description': '25 min work, 5 min break, repeat',
      'icon': '🍅',
    },
    'feynman': {
      'name': 'Feynman Technique',
      'duration': 90,
      'breakDuration': 10,
      'description': 'Study, teach, identify gaps, simplify',
      'icon': '🧠',
    },
    'deep_work': {
      'name': 'Deep Work',
      'duration': 180,
      'breakDuration': 20,
      'description': 'Extended focused work without distractions',
      'icon': '🎯',
    },
    'custom': {
      'name': 'Custom Session',
      'duration': 60,
      'breakDuration': 10,
      'description': 'Create your own study schedule',
      'icon': '⚙️',
    },
  };

  // Achievement System
  static const Map<String, Map<String, dynamic>> achievements = {
    'first_steps': {
      'name': 'First Steps',
      'description': 'Complete your first study session',
      'icon': '👶',
      'requirement': {'type': 'sessions', 'count': 1},
    },
    'getting_serious': {
      'name': 'Getting Serious',
      'description': 'Complete 5 study sessions',
      'icon': '📚',
      'requirement': {'type': 'sessions', 'count': 5},
    },
    'dedicated_scholar': {
      'name': 'Dedicated Scholar',
      'description': 'Study for more than 10 hours total',
      'icon': '🎓',
      'requirement': {'type': 'total_time', 'minutes': 600},
    },
    'pomodoro_master': {
      'name': 'Pomodoro Master',
      'description': 'Complete 3 Pomodoro sessions',
      'icon': '🍅',
      'requirement': {'type': 'technique_sessions', 'technique': 'pomodoro', 'count': 3},
    },
    'night_owl': {
      'name': 'Night Owl',
      'description': 'Study after 10 PM',
      'icon': '🦉',
      'requirement': {'type': 'time_of_day', 'hour': 22},
    },
    'task_master': {
      'name': 'Task Master',
      'description': 'Complete 10 tasks during study sessions',
      'icon': '✅',
      'requirement': {'type': 'tasks_completed', 'count': 10},
    },
  };

  // Quiz Difficulty Levels
  static const Map<String, String> difficultyLevels = {
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
    'prodigy': 'Prodigy',
  };

  // Ambient Sounds
  static const Map<String, String> ambientSounds = {
    'rain': 'Rain',
    'cafe': 'Cafe Ambience',
    'nature': 'Nature Sounds',
    'white_noise': 'White Noise',
    'ocean': 'Ocean Waves',
    'forest': 'Forest Sounds',
  };

  // YouTube Categories
  static const Map<String, String> youtubeCategories = {
    'education': 'Education',
    'science': 'Science',
    'mathematics': 'Mathematics',
    'programming': 'Programming',
    'history': 'History',
    'literature': 'Literature',
    'language': 'Language Learning',
    'music': 'Music Theory',
  };

  // Office Suite File Types
  static const Map<String, String> officeFileTypes = {
    'docx': 'Word Document',
    'xlsx': 'Excel Spreadsheet',
    'pptx': 'PowerPoint Presentation',
    'pdf': 'PDF Document',
    'txt': 'Text File',
  };

  // Database Tables
  static const String studySessionsTable = 'study_sessions';
  static const String achievementsTable = 'achievements';
  static const String tasksTable = 'tasks';
  static const String videosTable = 'videos';
  static const String playlistsTable = 'playlists';
  static const String quizzesTable = 'quizzes';
  static const String schedulesTable = 'schedules';
  static const String filesTable = 'files';

  // API Endpoints
  static const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';
  static const String geminiApiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  // Local Storage Keys
  static const String userSettingsKey = 'user_settings';
  static const String studyStatsKey = 'study_stats';
  static const String achievementsKey = 'achievements';
  static const String preferencesKey = 'preferences';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Timer Intervals
  static const Duration timerInterval = Duration(seconds: 1);
  static const Duration breakInterval = Duration(minutes: 1);

  // File Size Limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
}
