import 'package:uuid/uuid.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Map<String, dynamic> requirement;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    String? id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requirement,
    this.unlockedAt,
    this.isUnlocked = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'requirement': _mapToString(requirement),
      'unlocked_at': unlockedAt?.millisecondsSinceEpoch,
      'is_unlocked': isUnlocked ? 1 : 0,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      requirement: _stringToMap(map['requirement']),
      unlockedAt: map['unlocked_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlocked_at'])
          : null,
      isUnlocked: map['is_unlocked'] == 1,
    );
  }

  Achievement copyWith({
    String? name,
    String? description,
    String? icon,
    Map<String, dynamic>? requirement,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      requirement: requirement ?? this.requirement,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static String _mapToString(Map<String, dynamic> map) {
    return map.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
  }

  static Map<String, dynamic> _stringToMap(String str) {
    final Map<String, dynamic> result = {};
    if (str.isEmpty) return result;
    
    final pairs = str.split(',');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        final key = parts[0];
        final value = parts[1];
        // Try to parse as number, otherwise keep as string
        if (RegExp(r'^\d+$').hasMatch(value)) {
          result[key] = int.parse(value);
        } else if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
          result[key] = double.parse(value);
        } else {
          result[key] = value;
        }
      }
    }
    return result;
  }
}
