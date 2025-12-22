import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/study_session_provider.dart';
import '../screens/home_screen.dart';
import '../providers/app_provider.dart';

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
  }

  @override
  void dispose() {
    // Restore system UI when leaving kiosk mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudySessionProvider>(
      builder: (context, studyProvider, child) {
        if (!studyProvider.isKioskMode) {
          // If kiosk mode is disabled, return to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Show HomeScreen but in fullscreen kiosk mode
        return Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            // Track section changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              studyProvider.onSectionChanged(appProvider.currentSection);
            });
            
            return HomeScreen();
          },
        );
      },
    );
  }
}
