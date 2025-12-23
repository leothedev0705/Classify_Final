import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/study_session_provider.dart';
import '../screens/home_screen.dart';
import '../providers/app_provider.dart';
import '../services/kiosk_service.dart';

class KioskModeScreen extends StatefulWidget {
  const KioskModeScreen({Key? key}) : super(key: key);

  @override
  State<KioskModeScreen> createState() => _KioskModeScreenState();
}

class _KioskModeScreenState extends State<KioskModeScreen> {
  @override
  void initState() {
    super.initState();
    // Enter fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Enable true kiosk mode - blocks all system shortcuts
    _enableKioskMode();
  }
  
  Future<void> _enableKioskMode() async {
    await KioskService.enableKioskMode();
    await KioskService.blockNotifications(true);
  }

  @override
  void dispose() {
    // Only restore system UI if kiosk mode is actually disabled
    final studyProvider = Provider.of<StudySessionProvider>(context, listen: false);
    if (!studyProvider.isKioskMode) {
      _disableKioskMode();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }
  
  Future<void> _disableKioskMode() async {
    await KioskService.blockNotifications(false);
    await KioskService.disableKioskMode();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button from exiting
      child: Consumer<StudySessionProvider>(
        builder: (context, studyProvider, child) {
          if (!studyProvider.isKioskMode) {
            // If kiosk mode is disabled, return to home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            });
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Show HomeScreen but in fullscreen kiosk mode with persistent timer
          return Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              // Track section changes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                studyProvider.onSectionChanged(appProvider.currentSection);
              });
              
              return Stack(
                children: [
                  // Main content
                  HomeScreen(),
                  
                  // Persistent timer overlay at the top
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildTimerOverlay(studyProvider),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimerOverlay(StudySessionProvider studyProvider) {
    if (!studyProvider.isRunning || studyProvider.currentSession == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Session info
            Row(
              children: [
                Icon(
                  studyProvider.isBreak ? Icons.coffee : Icons.school,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studyProvider.isBreak ? 'Break Time' : 'Study Session',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      studyProvider.currentSession?.technique.toUpperCase() ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Timer display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    studyProvider.formattedTimeRemaining,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            
            // Control buttons
            Row(
              children: [
                // Pause/Resume button
                IconButton(
                  onPressed: () {
                    studyProvider.togglePause();
                  },
                  icon: Icon(
                    studyProvider.isPaused ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                  tooltip: studyProvider.isPaused ? 'Resume' : 'Pause',
                ),
                // Stop button (with confirmation)
                IconButton(
                  onPressed: () {
                    _showStopSessionDialog(studyProvider);
                  },
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.white,
                  ),
                  tooltip: 'Stop Session',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStopSessionDialog(StudySessionProvider studyProvider) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Stop Study Session?'),
        content: const Text(
          'Are you sure you want to stop the current study session? This will exit kiosk mode.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Disable kiosk mode first
              await _disableKioskMode();
              studyProvider.stopSession();
              // Navigate back to home
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Stop Session'),
          ),
        ],
      ),
    );
  }
}
