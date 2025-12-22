import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  String _inputMethod = '';
  bool _isGenerating = false;
  Map<String, dynamic>? _generatedSchedule;

  String get inputMethod => _inputMethod;
  bool get isGenerating => _isGenerating;
  Map<String, dynamic>? get generatedSchedule => _generatedSchedule;

  void setInputMethod(String method) {
    _inputMethod = method;
    notifyListeners();
  }

  Future<void> generateSchedule(Map<String, dynamic> data) async {
    _isGenerating = true;
    notifyListeners();

    // Simulate AI processing
    await Future.delayed(Duration(seconds: 3));

    // Generate mock schedule
    _generatedSchedule = {
      'startDate': data['startDate'],
      'endDate': data['endDate'],
      'days': {
        'Monday, Jan 15': [
          {'startTime': '18:00', 'endTime': '19:30', 'name': 'Mathematics Review'},
          {'startTime': '20:00', 'endTime': '21:30', 'name': 'Physics Problems'},
        ],
        'Tuesday, Jan 16': [
          {'startTime': '18:00', 'endTime': '19:00', 'name': 'Chemistry Lab Prep'},
          {'startTime': '19:30', 'endTime': '21:00', 'name': 'History Reading'},
        ],
      },
      'notes': 'This schedule is optimized for evening study sessions.',
    };

    _isGenerating = false;
    notifyListeners();
  }

  // Missing methods for compatibility
  Future<void> initialize() async {
    // Initialize schedule provider
  }

  Map<String, dynamic>? get currentSchedule => _generatedSchedule;
  List<Map<String, dynamic>> get schedules => _generatedSchedule != null ? [_generatedSchedule!] : [];

  void setCurrentSchedule(Map<String, dynamic> schedule) {
    _generatedSchedule = schedule;
    notifyListeners();
  }

  void clearCurrentSchedule() {
    _generatedSchedule = null;
    notifyListeners();
  }

  Future<void> generateScheduleWithParams({
    required List<Map<String, dynamic>> tasks,
    required String startDate,
    required String endDate,
    required List<Map<String, dynamic>> fixedActivities,
    required Map<String, dynamic> preferences,
  }) async {
    final data = {
      'startDate': startDate,
      'endDate': endDate,
      'tasks': tasks,
      'fixedActivities': fixedActivities,
      'preferences': preferences,
    };
    await generateSchedule(data);
  }
}
