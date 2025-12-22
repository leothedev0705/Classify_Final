import 'package:flutter/material.dart';
import 'package:studex_flutter/services/youtube_service.dart';
import 'package:studex_flutter/models/video.dart';

class YouTubeProvider extends ChangeNotifier {
  final YouTubeService _youtubeService = YouTubeService();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  // Library videos user saved
  final List<Video> _videos = [];
  // Last search results
  List<Video> _searchResults = [];
  // Trending/cache
  List<Video> _trendingVideos = [];
  // Simple in-memory notes and playlists
  final List<Map<String, dynamic>> _savedNotes = [];
  final List<Map<String, dynamic>> _playlists = [];
  bool _isLoading = false;
  String? _error;
  String? _warningMessage;

  // Ultra-strict study-safe filter
  static const List<String> _blockedKeywords = [
    // profanity (representative subset)
    'fuck','fucking','shit','bitch','bastard','asshole','dick','pussy','slut','whore','crap','damn','bloody',
    // entertainment/non-study
    'football','soccer','nba','nfl','ipl','cricket','fifa','highlights','goal','match','gameplay','gaming','let\'s play','stream',
    'music','song','lyric','lyrics','album','track','concert','dance','tiktok','reels','meme','prank','vlog','vlogger','challenge',
    'comedy','standup','stand-up','movie','trailer','bollywood','hollywood','netflix','prime video','series','episode','celebrity',
  ];

  // Educational allowlist – presence of any of these marks content as study-relevant
  static const List<String> _educationalKeywords = [
    'education','educational','study','learn','learning','revision','exam','lecture','tutorial','course','class',
    'notes','syllabus','worksheet','assignment','homework','practice','problems','solution','explanation','guide',
    'mathematics','math','algebra','calculus','geometry','trigonometry','statistics','probability',
    'physics','chemistry','biology','science','computer science','cs','programming','coding','software','engineering',
    'java','python','c++','c#','javascript','dart','flutter','android','data structures','algorithms'
  ];

  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  // Library videos
  List<Video> get videos => _videos;
  // Search results for current query
  List<Video> get searchResults => _searchResults;
  List<Video> get trendingVideos => _trendingVideos;
  List<Map<String, dynamic>> get savedNotes => _savedNotes;
  List<Map<String, dynamic>> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get warningMessage => _warningMessage;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> searchVideos(String query, {String? category}) async {
    if (query.isEmpty) return;
    
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final selectedCategory = (category ?? _selectedFilter).toLowerCase();
      final results = await _youtubeService.searchVideos(query, category: selectedCategory);
      final filtered = results.where(_isAllowedVideo).toList();
      _searchResults = filtered;
      _warningMessage = null;
      if (filtered.length < results.length) {
        _warningMessage = 'Some videos were hidden by Study Filter.';
      }
      if (filtered.isEmpty) {
        _warningMessage = 'Search blocked by Study Filter. Refocus on study topics.';
      }
    } catch (e) {
      _error = 'Failed to search videos: $e';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrendingVideos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _youtubeService.getTrendingVideos(category: 'education');
      _trendingVideos = results.where(_isAllowedVideo).toList();
    } catch (e) {
      _error = 'Failed to load trending videos: $e';
      _trendingVideos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void openVideoPlayer(String videoId, String title) {
    // Implement video player
  }

  // Playlist management for UI expectations
  void createPlaylist({required String name, required String description, required String category}) {
    _playlists.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'description': description,
      'videoCount': 0,
      'category': category,
    });
    notifyListeners();
  }

  bool _isAllowedVideo(Video video) {
    final text = (
      '${video.title} ${video.description} ${video.channelName} ${video.category}'
    ).toLowerCase();

    // Profanity always blocks
    for (final kw in _blockedKeywords) {
      if (text.contains(kw)) {
        // But if the keyword is from entertainment set (not profanity), and content
        // is clearly educational, allow it. We treat profanity terms as hard block.
        final isProfanity = ['fuck','fucking','shit','bitch','bastard','asshole','dick','pussy','slut','whore','crap','damn','bloody']
            .contains(kw);
        if (isProfanity) return false;
        // For entertainment keywords, only block if no educational context
        final hasEducational = _educationalKeywords.any((e) => text.contains(e));
        if (!hasEducational) return false;
      }
    }

    return true;
  }

  // Library actions
  void addVideo(Video video) {
    if (_videos.any((v) => v.id == video.id)) return;
    _videos.add(video);
    notifyListeners();
  }

  void removeVideo(String videoId) {
    _videos.removeWhere((v) => v.id == videoId);
    notifyListeners();
  }

  void toggleFavorite(String videoId) {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index == -1) return;
    final current = _videos[index];
    _videos[index] = current.copyWith(isFavorite: !current.isFavorite);
    notifyListeners();
  }

  // Initialize method for compatibility
  Future<void> initialize() async {
    await loadTrendingVideos();
  }
}
