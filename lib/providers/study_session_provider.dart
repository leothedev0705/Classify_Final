import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/study_session.dart';

class StudySessionProvider extends ChangeNotifier {
  String _selectedTechnique = 'pomodoro';
  String _selectedSound = 'None';
  bool _phoneDetectionEnabled = false;
  bool _isKioskMode = false;
  bool _isPaused = false;
  List<String> _tasks = [];
  
  // Timer properties
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  DateTime? _sessionStartTime;
  Timer? _timer;
  bool _isRunning = false;
  
  // Section tracking
  String? _currentSection;
  DateTime? _sectionStartTime;
  Map<String, int> _sectionTimeSpent = {}; // section -> seconds
  
  // Completed sessions storage
  List<StudySession> _completedSessions = [];
  
  // Audio player for ambient sounds
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingSound = false;

  String get selectedTechnique => _selectedTechnique;
  String get selectedSound => _selectedSound;
  bool get phoneDetectionEnabled => _phoneDetectionEnabled;
  bool get isKioskMode => _isKioskMode;
  bool get isPaused => _isPaused;
  bool get isRunning => _isRunning;
  List<String> get tasks => _tasks;

  String get formattedTime {
    final hours = _remainingSeconds ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get sessionLabel {
    switch (_selectedTechnique) {
      case 'pomodoro':
        return 'Study Time';
      case 'feynman':
        return 'Learning Time';
      case 'deep':
        return 'Deep Work';
      default:
        return 'Study Time';
    }
  }

  String get selectedTechniqueName {
    switch (_selectedTechnique) {
      case 'pomodoro':
        return 'Pomodoro Technique';
      case 'feynman':
        return 'Feynman Technique';
      case 'deep':
        return 'Deep Work';
      default:
        return 'Custom Session';
    }
  }

  double get progress {
    if (_totalSeconds == 0) return 0.0;
    return 1.0 - (_remainingSeconds / _totalSeconds);
  }

  void selectTechnique(String technique) {
    _selectedTechnique = technique;
    notifyListeners();
  }

  void selectSound(String sound) {
    _selectedSound = sound;
    _playSelectedSound();
    notifyListeners();
  }
  
  void _playSelectedSound() async {
    // Stop current sound
    await _audioPlayer.stop();
    _isPlayingSound = false;
    
    if (_selectedSound != 'None') {
      try {
        String soundPath = _getSoundPath(_selectedSound);
        await _audioPlayer.play(AssetSource(soundPath));
        _isPlayingSound = true;
      } catch (e) {
        print('Error playing sound: $e');
        // Fallback: continue without sound
      }
    }
  }
  
  String _getSoundPath(String soundName) {
    switch (soundName) {
      case 'Rain':
        return 'sounds/rain.mp3';
      case 'Cafe':
        return 'sounds/cafe.mp3';
      case 'Nature':
        return 'sounds/nature.mp3';
      case 'White Noise':
        return 'sounds/white-noise.mp3';
      default:
        return '';
    }
  }

  void togglePhoneDetection() {
    _phoneDetectionEnabled = !_phoneDetectionEnabled;
    notifyListeners();
  }

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void startSession({String? technique, int? durationHours}) {
    // Stop any existing timer
    _timer?.cancel();
    
    // Reset section tracking
    _sectionTimeSpent = {};
    _currentSection = 'study-session'; // Start tracking from study session section
    _sectionStartTime = DateTime.now();
    
    _isKioskMode = true;
    _isRunning = true;
    _isPaused = false;
    _sessionStartTime = DateTime.now();
    
    // Use provided technique or default
    if (technique != null) {
      _selectedTechnique = technique;
    }
    
    // Calculate duration in seconds based on hours provided or technique default
    if (durationHours != null) {
      _totalSeconds = durationHours * 3600; // Convert hours to seconds
    } else {
      // Set duration based on technique
      switch (_selectedTechnique) {
        case 'pomodoro':
          _totalSeconds = 120 * 60; // 2 hours default
          break;
        case 'flow':
          _totalSeconds = 60 * 60; // 1 hour default
          break;
        case 'timeblocking':
          _totalSeconds = 180 * 60; // 3 hours default
          break;
        case 'deepfocus':
          _totalSeconds = 120 * 60; // 2 hours default
          break;
        default:
          _totalSeconds = 60 * 60; // 1 hour default
      }
    }
    
    _remainingSeconds = _totalSeconds;
    
    // Start the timer
    _startTimer();
    
    // Play ambient sound if selected
    if (_selectedSound != 'None') {
      _playSelectedSound();
    }
    
    notifyListeners();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
        
        if (_remainingSeconds == 0) {
          _onTimerComplete();
        }
      }
    });
  }
  
  void _onTimerComplete() {
    _timer?.cancel();
    _isRunning = false;
    // You can add notification or sound here
    notifyListeners();
  }

  void togglePause() {
    _isPaused = !_isPaused;
    if (!_isPaused && _isRunning) {
      // Resume timer if it was running
      _startTimer();
      // Resume section tracking
      if (_currentSection != null) {
        _sectionStartTime = DateTime.now();
      }
    } else if (_isPaused) {
      // Record time spent in current section when pausing
      if (_currentSection != null && _sectionStartTime != null) {
        final now = DateTime.now();
        final timeSpent = now.difference(_sectionStartTime!).inSeconds;
        _sectionTimeSpent[_currentSection!] = 
            (_sectionTimeSpent[_currentSection!] ?? 0) + timeSpent;
        _sectionStartTime = null;
      }
    }
    notifyListeners();
  }

  void endSession() {
    // Record final section time
    if (_currentSection != null && _sectionStartTime != null && _sessionStartTime != null) {
      final now = DateTime.now();
      final timeSpent = now.difference(_sectionStartTime!).inSeconds;
      _sectionTimeSpent[_currentSection!] = 
          (_sectionTimeSpent[_currentSection!] ?? 0) + timeSpent;
    }
    
    // Save completed session
    if (_sessionStartTime != null) {
      final actualDuration = DateTime.now().difference(_sessionStartTime!).inMinutes;
      final completedSession = StudySession(
        technique: _selectedTechnique,
        duration: _totalSeconds ~/ 60,
        breakDuration: 0,
        startTime: _sessionStartTime!,
        endTime: DateTime.now(),
        tasks: List.from(_tasks),
        notes: '',
        isCompleted: true,
        ambientSound: _selectedSound,
        actualDuration: actualDuration,
        sectionTimeSpent: Map.from(_sectionTimeSpent),
      );
      
      _completedSessions.insert(0, completedSession);
      // Keep only last 100 sessions
      if (_completedSessions.length > 100) {
        _completedSessions = _completedSessions.sublist(0, 100);
      }
    }
    
    _timer?.cancel();
    _isKioskMode = false;
    _isPaused = false;
    _isRunning = false;
    _remainingSeconds = 0;
    _totalSeconds = 0;
    _sessionStartTime = null;
    _currentSection = null;
    _sectionStartTime = null;
    _sectionTimeSpent = {};
    
    // Stop ambient sound
    _audioPlayer.stop();
    _isPlayingSound = false;
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Missing methods for compatibility
  Future<void> initialize() async {
    // Initialize study session provider
  }

  Map<String, dynamic>? get currentSession => null; // Return null for now
  bool get isBreak => false; // Return false for now
  String get formattedTimeRemaining => '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}';
  Duration get todayStudyTime => Duration(minutes: 0); // Return 0 for now
  int get sessionsCount => 0; // Return 0 for now
  Duration get weeklyStudyTime => Duration(minutes: 0); // Return 0 for now
  List<Map<String, dynamic>> get achievements => []; // Return empty list for now
  List<StudySession> get completedSessions => List.unmodifiable(_completedSessions);
  
  // Track section changes
  void onSectionChanged(String section) {
    if (!_isRunning || _isPaused) return;
    
    final now = DateTime.now();
    
    // Record time spent in previous section
    if (_currentSection != null && _sectionStartTime != null) {
      final timeSpent = now.difference(_sectionStartTime!).inSeconds;
      _sectionTimeSpent[_currentSection!] = 
          (_sectionTimeSpent[_currentSection!] ?? 0) + timeSpent;
    }
    
    // Start tracking new section
    _currentSection = section;
    _sectionStartTime = now;
    
    notifyListeners();
  }
  
  // Get formatted section name
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
}
