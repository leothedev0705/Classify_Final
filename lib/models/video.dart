import 'package:uuid/uuid.dart';

class Video {
  final String id;
  final String youtubeId;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelName;
  final Duration duration;
  final String category;
  final List<String> tags;
  final DateTime addedAt;
  final String? notes;
  final String? summary;
  final bool isFavorite;
  final String? playlistId;

  Video({
    String? id,
    required this.youtubeId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelName,
    required this.duration,
    required this.category,
    this.tags = const [],
    DateTime? addedAt,
    this.notes,
    this.summary,
    this.isFavorite = false,
    this.playlistId,
  }) : id = id ?? const Uuid().v4(),
       addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'youtube_id': youtubeId,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'channel_name': channelName,
      'duration': duration.inSeconds,
      'category': category,
      'tags': tags.join(','),
      'added_at': addedAt.millisecondsSinceEpoch,
      'notes': notes,
      'summary': summary,
      'is_favorite': isFavorite ? 1 : 0,
      'playlist_id': playlistId,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      youtubeId: map['youtube_id'],
      title: map['title'],
      description: map['description'],
      thumbnailUrl: map['thumbnail_url'],
      channelName: map['channel_name'],
      duration: Duration(seconds: map['duration']),
      category: map['category'],
      tags: map['tags'] != null && map['tags'].isNotEmpty
          ? map['tags'].split(',')
          : [],
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['added_at']),
      notes: map['notes'],
      summary: map['summary'],
      isFavorite: map['is_favorite'] == 1,
      playlistId: map['playlist_id'],
    );
  }

  Video copyWith({
    String? youtubeId,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? channelName,
    Duration? duration,
    String? category,
    List<String>? tags,
    DateTime? addedAt,
    String? notes,
    String? summary,
    bool? isFavorite,
    String? playlistId,
  }) {
    return Video(
      id: id,
      youtubeId: youtubeId ?? this.youtubeId,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      channelName: channelName ?? this.channelName,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      addedAt: addedAt ?? this.addedAt,
      notes: notes ?? this.notes,
      summary: summary ?? this.summary,
      isFavorite: isFavorite ?? this.isFavorite,
      playlistId: playlistId ?? this.playlistId,
    );
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

class Playlist {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> videoIds;
  final DateTime createdAt;
  final bool isPublic;

  Playlist({
    String? id,
    required this.name,
    required this.description,
    required this.category,
    this.videoIds = const [],
    DateTime? createdAt,
    this.isPublic = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'video_ids': videoIds.join(','),
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_public': isPublic ? 1 : 0,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      videoIds: map['video_ids'] != null && map['video_ids'].isNotEmpty
          ? map['video_ids'].split(',')
          : [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      isPublic: map['is_public'] == 1,
    );
  }

  Playlist copyWith({
    String? name,
    String? description,
    String? category,
    List<String>? videoIds,
    DateTime? createdAt,
    bool? isPublic,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      videoIds: videoIds ?? this.videoIds,
      createdAt: createdAt ?? this.createdAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  int get videoCount => videoIds.length;
}
