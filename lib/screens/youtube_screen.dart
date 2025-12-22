import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/youtube_provider.dart';
import 'package:studex_flutter/constants/app_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:studex_flutter/models/video.dart';

class YouTubeScreen extends StatefulWidget {
  const YouTubeScreen({super.key});

  @override
  State<YouTubeScreen> createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'education';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Educational Videos'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Search', icon: Icon(Icons.search)),
            Tab(text: 'Library', icon: Icon(Icons.video_library)),
            Tab(text: 'Playlists', icon: Icon(Icons.playlist_play)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSearchTab(),
          _buildLibraryTab(),
          _buildPlaylistsTab(),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Consumer<YouTubeProvider>(
      builder: (context, youtubeProvider, child) {
        return Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search educational videos...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _searchVideos(youtubeProvider);
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _searchVideos(youtubeProvider);
                    },
                  ),
                  const SizedBox(height: 12),
                  // Category Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppConstants.youtubeCategories.entries.map((entry) {
                        final isSelected = _selectedCategory == entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(entry.value),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = entry.key;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Results
            Expanded(
              child: youtubeProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : youtubeProvider.searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'Search for educational videos to get started',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: youtubeProvider.searchResults.length,
                          itemBuilder: (context, index) {
                            final video = youtubeProvider.searchResults[index];
                            return _buildVideoCard(video, youtubeProvider);
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLibraryTab() {
    return Consumer<YouTubeProvider>(
      builder: (context, youtubeProvider, child) {
        return youtubeProvider.videos.isEmpty
            ? const Center(
                child: Text(
                  'No videos in your library yet',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: youtubeProvider.videos.length,
                itemBuilder: (context, index) {
                  final video = youtubeProvider.videos[index];
                  return _buildVideoCard(video, youtubeProvider, isLibrary: true);
                },
              );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return Consumer<YouTubeProvider>(
      builder: (context, youtubeProvider, child) {
        return Column(
          children: [
            // Create Playlist Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showCreatePlaylistDialog(youtubeProvider);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Playlist'),
                ),
              ),
            ),
            
            // Playlists List
            Expanded(
              child: youtubeProvider.playlists.isEmpty
                  ? const Center(
                      child: Text(
                        'No playlists created yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: youtubeProvider.playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = youtubeProvider.playlists[index];
                        return _buildPlaylistCard(playlist, youtubeProvider);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoCard(dynamic video, YouTubeProvider youtubeProvider, {bool isLibrary = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showVideoDetails(video, youtubeProvider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  image: (!kIsWeb && video.thumbnailUrl.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(video.thumbnailUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: kIsWeb ? Colors.grey[600] : Colors.white,
                    size: 32,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Video Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.channelName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.formattedDuration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if (isLibrary) {
                        youtubeProvider.removeVideo(video.id);
                      } else {
                        youtubeProvider.addVideo(video);
                      }
                    },
                    icon: Icon(
                      isLibrary ? Icons.remove_circle : Icons.add_circle,
                      color: isLibrary ? Colors.red : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (isLibrary)
                    IconButton(
                      onPressed: () {
                        youtubeProvider.toggleFavorite(video.id);
                      },
                      icon: Icon(
                        video.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: video.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(dynamic playlist, YouTubeProvider youtubeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.playlist_play,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(playlist.name),
        subtitle: Text('${playlist.videoCount} videos'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeletePlaylistDialog(playlist, youtubeProvider);
            }
          },
        ),
        onTap: () {
          _showPlaylistDetails(playlist, youtubeProvider);
        },
      ),
    );
  }

  void _searchVideos(YouTubeProvider youtubeProvider) {
    if (_searchController.text.isNotEmpty) {
      youtubeProvider.searchVideos(
        _searchController.text,
        category: _selectedCategory,
      );
    }
  }

  void _playVideo(dynamic video) {
    // Extract video ID properly
    String videoId = video.youtubeId ?? video.id;
    if (videoId.contains('youtube.com') || videoId.contains('youtu.be')) {
      videoId = YoutubePlayer.convertUrlToId(videoId) ?? videoId;
    }
    
    if (videoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid video ID')),
      );
      return;
    }

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        loop: false,
        isLive: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
        hideControls: false,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, box) {
            final maxW = box.maxWidth;
            final maxH = box.maxHeight;
            final availableH = (maxH - 52).clamp(180.0, maxH);
            double playerW = maxW;
            double playerH = playerW * 9 / 16;
            if (playerH > availableH) {
              playerH = availableH;
              playerW = playerH * 16 / 9;
            }
            return ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 320,
                minHeight: 220,
                maxWidth: MediaQuery.of(context).size.width * 0.95,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: playerW,
                    height: playerH,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: YoutubePlayer(
                        controller: controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.blueAccent,
                          handleColor: Colors.blueAccent,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.grey,
                        ),
                        onReady: () {
                          // Wait for controller to be fully ready before playing
                          Future.delayed(const Duration(milliseconds: 500), () {
                            try {
                              if (controller.value.isReady) {
                                controller.play();
                              } else {
                                // If not ready, wait a bit more and try again
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  if (controller.value.isReady && !controller.value.isPlaying) {
                                    controller.play();
                                  }
                                });
                              }
                            } catch (e) {
                              debugPrint('Error playing video: $e');
                            }
                          });
                        },
                        aspectRatio: 16 / 9,
                        bufferIndicator: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            video.title ?? 'Video',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF353E6C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.pause();
                            Navigator.of(context).pop();
                            controller.dispose();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ).then((_) {
      controller.pause();
      controller.dispose();
    });
  }

  void _showVideoDetails(dynamic video, YouTubeProvider youtubeProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: (!kIsWeb && video.thumbnailUrl.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(video.thumbnailUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: kIsWeb ? Colors.grey[600] : Colors.white,
                  size: 64,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Video Title
            Text(
              video.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Channel Name
            Text(
              video.channelName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              video.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Open video player
                      _playVideo(video);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Video'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      youtubeProvider.addVideo(video);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video added to library')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Library'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(YouTubeProvider youtubeProvider) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'education';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.youtubeCategories.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                youtubeProvider.createPlaylist(
                  name: nameController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Playlist created')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showPlaylistDetails(dynamic playlist, YouTubeProvider youtubeProvider) {
    // Implementation for showing playlist details
  }

  void _showDeletePlaylistDialog(dynamic playlist, YouTubeProvider youtubeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete playlist logic
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
