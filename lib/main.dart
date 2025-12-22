import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/study_session_provider.dart';
import 'providers/youtube_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/file_provider.dart';
import 'themes/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/webview_init.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize WebView platform
  initializeWebView();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => StudySessionProvider()),
        ChangeNotifierProvider(create: (_) => YouTubeProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'StuDex - Study Session Manager',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: authProvider.isAuthenticated ? HomeScreen() : LoginScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
