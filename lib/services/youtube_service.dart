import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studex_flutter/models/video.dart';
import 'package:studex_flutter/constants/app_constants.dart';
import 'package:studex_flutter/constants/api_keys.dart';

class YouTubeService {
  static const String _apiKey = ApiKeys.youtubeApiKey;
  static const String _baseUrl = ApiKeys.youtubeBaseUrl;

  // Search for videos
  Future<List<Video>> searchVideos(String query, {String category = 'education'}) async {
    try {
      final url = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'key': _apiKey,
        'maxResults': '20',
        'order': 'relevance',
        'videoCategoryId': _getCategoryId(category),
      });

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseSearchResults(data);
      } else {
        throw Exception('Failed to search videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching videos: $e');
    }
  }

  // Get video details
  Future<Video> getVideoDetails(String videoId) async {
    try {
      final url = Uri.parse('$_baseUrl/videos').replace(queryParameters: {
        'part': 'snippet,contentDetails',
        'id': videoId,
        'key': _apiKey,
      });

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseVideoDetails(data);
      } else {
        throw Exception('Failed to get video details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting video details: $e');
    }
  }

  // Parse search results
  List<Video> _parseSearchResults(Map<String, dynamic> data) {
    final List<Video> videos = [];
    
    if (data['items'] != null) {
      for (final item in data['items']) {
        try {
          final snippet = item['snippet'];
          final video = Video(
            youtubeId: item['id']['videoId'],
            title: snippet['title'],
            description: snippet['description'],
            thumbnailUrl: snippet['thumbnails']['high']['url'],
            channelName: snippet['channelTitle'],
            duration: const Duration(seconds: 0), // Duration not available in search results
            category: _getCategoryFromSnippet(snippet),
          );
          videos.add(video);
        } catch (e) {
          // Skip invalid items
          continue;
        }
      }
    }
    
    return videos;
  }

  // Parse video details
  Video _parseVideoDetails(Map<String, dynamic> data) {
    if (data['items'] == null || data['items'].isEmpty) {
      throw Exception('Video not found');
    }
    
    final item = data['items'][0];
    final snippet = item['snippet'];
    final contentDetails = item['contentDetails'];
    
    return Video(
      youtubeId: item['id'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelName: snippet['channelTitle'],
      duration: _parseDuration(contentDetails['duration']),
      category: _getCategoryFromSnippet(snippet),
    );
  }

  // Parse ISO 8601 duration to Duration object
  Duration _parseDuration(String iso8601Duration) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(iso8601Duration);
    
    if (match == null) return const Duration(seconds: 0);
    
    final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;
    
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // Get category ID for YouTube API
  String _getCategoryId(String category) {
    const categoryMap = {
      'education': '27',
      'science': '28',
      'technology': '28',
      'music': '10',
      'gaming': '20',
      'sports': '17',
      'news': '25',
    };
    
    return categoryMap[category] ?? '27'; // Default to education
  }

  // Get category from snippet
  String _getCategoryFromSnippet(Map<String, dynamic> snippet) {
    // Try to determine category from title and description
    final title = snippet['title']?.toLowerCase() ?? '';
    final description = snippet['description']?.toLowerCase() ?? '';
    final text = '$title $description';
    
    if (text.contains('math') || text.contains('mathematics')) {
      return 'mathematics';
    } else if (text.contains('science') || text.contains('physics') || text.contains('chemistry')) {
      return 'science';
    } else if (text.contains('programming') || text.contains('coding') || text.contains('computer')) {
      return 'programming';
    } else if (text.contains('history')) {
      return 'history';
    } else if (text.contains('literature') || text.contains('english') || text.contains('writing')) {
      return 'literature';
    } else if (text.contains('language') || text.contains('learn')) {
      return 'language';
    } else if (text.contains('music')) {
      return 'music';
    } else {
      return 'education';
    }
  }

  // Get trending educational videos
  Future<List<Video>> getTrendingVideos({String category = 'education'}) async {
    try {
      final url = Uri.parse('$_baseUrl/videos').replace(queryParameters: {
        'part': 'snippet,contentDetails',
        'chart': 'mostPopular',
        'key': _apiKey,
        'maxResults': '20',
        'videoCategoryId': _getCategoryId(category),
      });

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseTrendingResults(data);
      } else {
        throw Exception('Failed to get trending videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting trending videos: $e');
    }
  }

  // Parse trending results
  List<Video> _parseTrendingResults(Map<String, dynamic> data) {
    final List<Video> videos = [];
    
    if (data['items'] != null) {
      for (final item in data['items']) {
        try {
          final snippet = item['snippet'];
          final contentDetails = item['contentDetails'];
          
          final video = Video(
            youtubeId: item['id'],
            title: snippet['title'],
            description: snippet['description'],
            thumbnailUrl: snippet['thumbnails']['high']['url'],
            channelName: snippet['channelTitle'],
            duration: _parseDuration(contentDetails['duration']),
            category: _getCategoryFromSnippet(snippet),
          );
          videos.add(video);
        } catch (e) {
          // Skip invalid items
          continue;
        }
      }
    }
    
    return videos;
  }

  // Get channel videos
  Future<List<Video>> getChannelVideos(String channelId, {int maxResults = 20}) async {
    try {
      final url = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'part': 'snippet',
        'channelId': channelId,
        'type': 'video',
        'key': _apiKey,
        'maxResults': maxResults.toString(),
        'order': 'date',
      });

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseSearchResults(data);
      } else {
        throw Exception('Failed to get channel videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting channel videos: $e');
    }
  }
}
