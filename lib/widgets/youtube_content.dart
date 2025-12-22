import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:provider/provider.dart';
import '../providers/youtube_provider.dart';
import '../models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../themes/app_theme.dart';
import 'TopMostInfoBox/top_most_info_box.dart';

class YouTubeContent extends StatefulWidget {
  const YouTubeContent({Key? key}) : super(key: key);

  @override
  _YouTubeContentState createState() => _YouTubeContentState();
}

class _YouTubeContentState extends State<YouTubeContent> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  int selectedTab = 2; // 0 = Videos, 1 = Playlists, 2 = Saved Notes (default to Saved Notes as shown in image)

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TopMost Info Box
          const TopMostInfoBox(
            title: 'Explore Video Content',
            subtitle: 'Search and watch educational videos.',
            imageAsset: 'assets/images/EdutubeChar.png',
          ),
          const SizedBox(height: 24),
          // Content area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Explore Video Content',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF353E6C),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Search bar and tabs inside white box
                Row(
                  children: [
                    // Search field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC5C7D0), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 14),
                              child: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    context.read<YouTubeProvider>().searchVideos(value.trim());
                                    setState(() => selectedTab = 0);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Tab buttons
                    _buildTabButton('Videos', 0),
                    const SizedBox(width: 8),
                    _buildTabButton('PlayLists', 1),
                    const SizedBox(width: 8),
                    _buildTabButton('Saved Notes', 2),
                  ],
                ),
                const SizedBox(height: 24),
                // Content area
                _buildContentArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    switch (selectedTab) {
      case 0: // Videos
        return Consumer<YouTubeProvider>(
          builder: (context, yt, _) {
            final List<Video> items = yt.searchResults.isNotEmpty ? yt.searchResults : yt.trendingVideos;
            if (yt.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // Build banner (if any) plus results (if any)
            final List<Widget> children = [];
            if (yt.warningMessage != null) {
              children.add(
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text(
                    'Study Filter active: entertainment/profanity blocked. Get back to learning!',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              );
              children.add(const SizedBox(height: 12));
            }

            if (items.isEmpty) {
              children.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      yt.warningMessage ?? 'Search to see educational videos',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: const Color(0xFF353E6C).withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              children.add(_buildVideosGrid(items));
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
          },
        );
      case 1: // Playlists
        return _buildPlaylistsContent();
      case 2: // Saved Notes
        return _buildSavedNotesGrid();
      default:
        return Consumer<YouTubeProvider>(
          builder: (context, yt, _) => _buildVideosGrid(yt.trendingVideos),
        );
    }
  }

  Widget _buildVideosGrid(List<Video> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final v = videos[index];
            return InkWell(
              onTap: () => _openVideo(v),
              child: _buildVideoCard(v.title, v.channelName, thumbnailUrl: v.thumbnailUrl),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaylistsContent() {
    return Center(
      child: Text(
        'Playlists content will appear here',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: const Color(0xFF353E6C).withOpacity(0.5),
        ),
      ),
    );
  }

  Future<void> _openVideo(Video video) async {
    // Extract video ID properly (handle both full URLs and IDs)
    String videoId = video.youtubeId;
    if (videoId.contains('youtube.com') || videoId.contains('youtu.be')) {
      videoId = YoutubePlayer.convertUrlToId(videoId) ?? video.youtubeId;
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
        autoPlay: true, // Enable auto-play so video starts immediately
        mute: false,
        enableCaption: true,
        loop: false,
        isLive: false,
        forceHD: false,
        controlsVisibleAtStart: true,
        useHybridComposition: true,
        hideControls: false,
        hideThumbnail: false,
        showLiveFullscreenButton: true,
        startAt: 0,
      ),
    );

    final screen = MediaQuery.of(context).size;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, box) {
            final maxW = box.maxWidth;
            final maxH = box.maxHeight;
            // Reserve 52px for the action row
            final availableH = (maxH - 52).clamp(180.0, maxH);
            // Compute player size to fit within dialog while preserving 16:9
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
                maxWidth: screen.width * 0.95,
                maxHeight: screen.height * 0.9,
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
                        onEnded: (YoutubeMetaData metaData) {
                          // Video ended
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
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF353E6C),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        TextButton(
                          onPressed: () {
                            controller.pause();
                            Navigator.of(context).pop();
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
    );
    controller.pause();
    controller.dispose();
  }

  Widget _buildSavedNotesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return _buildVideoCard('Video Title ${index + 1}', 'Subtitle ${index + 1}');
          },
        ),
      ],
    );
  }

 Widget _buildVideoCard(String title, String subtitle, {String? thumbnailUrl}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail placeholder (white area)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                image: (thumbnailUrl != null && !kIsWeb)
                    ? DecorationImage(image: NetworkImage(thumbnailUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: (thumbnailUrl == null || kIsWeb)
                  ? Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.grey[400],
                        size: 48,
                      ),
                    )
                  : null,
            ),
          ),
        ),

         // Content area (light grey background)
         Container(
           width: double.infinity,
           height: 100,
           decoration: const BoxDecoration(
             color: Color(0xFFF8F9FA),
             borderRadius: BorderRadius.only(
               bottomLeft: Radius.circular(10),
               bottomRight: Radius.circular(10),
             ),
           ),
           // 🔽 Reduced bottom padding to minimal space
           padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF353E6C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF353E6C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          border: Border.all(color: const Color(0xFF353E6C)),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Center(
                          child: Text(
                            'Add to Playlist',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF353E6C),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                         height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          border: Border.all(color: const Color(0xFF353E6C)),
                           borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Summarize',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF353E6C),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int tabIndex) {
    final isSelected = selectedTab == tabIndex;
    return InkWell(
      onTap: () => setState(() => selectedTab = tabIndex),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF353E6C) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF353E6C),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF353E6C),
            ),
          ),
        ),
      ),
    );
  }
}
