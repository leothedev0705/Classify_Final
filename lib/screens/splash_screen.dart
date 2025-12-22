import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/screens/main_navigation.dart';
import 'package:studex_flutter/providers/study_session_provider.dart';
import 'package:studex_flutter/providers/quiz_provider.dart';
import 'package:studex_flutter/providers/youtube_provider.dart';
import 'package:studex_flutter/providers/chat_provider.dart';
import 'package:studex_flutter/providers/schedule_provider.dart';
import 'package:studex_flutter/providers/file_provider.dart';
import 'package:studex_flutter/providers/settings_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize all providers
      await Future.wait([
        Provider.of<StudySessionProvider>(context, listen: false).initialize(),
        Provider.of<QuizProvider>(context, listen: false).initialize(),
        Provider.of<YouTubeProvider>(context, listen: false).initialize(),
        Provider.of<ChatProvider>(context, listen: false).initialize(),
        Provider.of<ScheduleProvider>(context, listen: false).initialize(),
        Provider.of<FileProvider>(context, listen: false).initialize(),
        Provider.of<SettingsProvider>(context, listen: false).initialize(),
      ]);

      // Wait for animation to complete
      await _animationController.forward();
      
      // Navigate to main screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');
      // Still navigate to main screen even if initialization fails
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 60,
                        color: Color(0xFF3498db),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // App Name
                    Text(
                      'StuDex',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // App Tagline
                    Text(
                      'Study Session Manager',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Loading indicator
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
