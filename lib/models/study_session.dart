import 'package:uuid/uuid.dart';

class StudySession {
  final String id;
  final String technique;
  final int duration; // in minutes
  final int breakDuration; // in minutes
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> tasks;
  final String notes;
  final bool isCompleted;
  final String? ambientSound;
  final int actualDuration; // actual time spent in minutes
  final Map<String, int> sectionTimeSpent; // section name -> seconds spent

  StudySession({
    String? id,
    required this.technique,
    required this.duration,
    required this.breakDuration,
    required this.startTime,
    this.endTime,
    this.tasks = const [],
    this.notes = '',
    this.isCompleted = false,
    this.ambientSound,
    this.actualDuration = 0,
    this.sectionTimeSpent = const {},
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'technique': technique,
      'duration': duration,
      'break_duration': breakDuration,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime?.millisecondsSinceEpoch,
      'tasks': tasks.join(','),
      'notes': notes,
      'is_completed': isCompleted ? 1 : 0,
      'ambient_sound': ambientSound,
      'actual_duration': actualDuration,
      'section_time_spent': sectionTimeSpent.map((k, v) => MapEntry(k, v)),
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      technique: map['technique'],
      duration: map['duration'],
      breakDuration: map['break_duration'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time']),
      endTime: map['end_time'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['end_time'])
          : null,
      tasks: map['tasks'] != null && map['tasks'].isNotEmpty
          ? map['tasks'].split(',')
          : [],
      notes: map['notes'] ?? '',
      isCompleted: map['is_completed'] == 1,
      ambientSound: map['ambient_sound'],
      actualDuration: map['actual_duration'] ?? 0,
      sectionTimeSpent: map['section_time_spent'] != null
          ? Map<String, int>.from(map['section_time_spent'])
          : {},
    );
  }

  StudySession copyWith({
    String? technique,
    int? duration,
    int? breakDuration,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? tasks,
    String? notes,
    bool? isCompleted,
    String? ambientSound,
    int? actualDuration,
    Map<String, int>? sectionTimeSpent,
  }) {
    return StudySession(
      id: id,
      technique: technique ?? this.technique,
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tasks: tasks ?? this.tasks,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      ambientSound: ambientSound ?? this.ambientSound,
      actualDuration: actualDuration ?? this.actualDuration,
      sectionTimeSpent: sectionTimeSpent ?? this.sectionTimeSpent,
    );
  }

  double get progress {
    if (endTime == null) return 0.0;
    final totalDuration = duration + breakDuration;
    final elapsed = DateTime.now().difference(startTime).inMinutes;
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  bool get isActive {
    return !isCompleted && endTime == null;
  }

  Duration get remainingTime {
    if (endTime != null) return Duration.zero;
    final elapsed = DateTime.now().difference(startTime);
    final totalDuration = Duration(minutes: duration);
    return totalDuration - elapsed;
  }
}
