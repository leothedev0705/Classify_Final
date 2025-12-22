# Classify - Study Session Manager

A comprehensive study productivity app with kiosk mode, multiple study techniques, AI-powered features, and educational content management.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 🚀 Features

### 🎯 Study Session Management
- **Multiple Study Techniques**: Pomodoro, Feynman, Deep Work, and Custom sessions
- **Timer System**: Countdown with visual progress, pause/resume functionality
- **Kiosk Mode**: Full-screen mode that prevents access to other apps
- **Task Management**: Add and track tasks during study sessions
- **Session Notes**: Take notes during study sessions
- **Ambient Sounds**: Background sounds for focus (rain, cafe, nature, etc.)

### 📊 Dashboard & Analytics
- **Statistics Dashboard**: Total study time, sessions completed, achievements
- **Weekly Progress**: Visual charts showing study progress
- **Achievement System**: Unlock achievements based on study milestones
- **Calendar Integration**: Study calendar view and session scheduling

### 🤖 AI-Powered Quiz Generator
- **Smart Quiz Creation**: Generate quizzes using AI based on topics and difficulty
- **Interactive Interface**: Flashcard-style quiz interface with animations
- **Multiple Difficulty Levels**: Easy, Medium, Hard, and Prodigy
- **Results & Analysis**: Score tracking and performance analysis

### 📺 Educational Content Management
- **YouTube Integration**: Search and manage educational videos
- **Video Player**: Embedded video player with note-taking
- **AI Summarization**: Generate video summaries using AI
- **Playlist Management**: Create and organize video playlists
- **Content Organization**: Categorize and favorite videos

### 💬 AI Educational Assistant
- **Smart Chat Interface**: Educational query detection and content filtering
- **Content Filtering**: Off-topic warning system with timeout mechanism
- **Knowledge Base**: Support for Mathematics, Science, Programming, History, Literature

### 📁 Office Suite Integration
- **Document Creation**: Word, Excel, PowerPoint, and text documents via Office Online
- **File Management**: File explorer with organization features
- **Template Support**: Create documents from templates
- **File Preview**: View PDFs, text files, and documents

### 📅 AI Schedule Generator
- **Smart Scheduling**: Generate optimized study schedules using AI
- **Multiple Input Methods**: Manual form input or image upload (exam timetable)
- **Schedule Optimization**: Time slot optimization and activity balancing
- **Visual Calendar**: Interactive calendar with daily breakdown

### 🎵 Ambient Environment
- **Background Sounds**: Rain, cafe ambience, nature sounds, white noise
- **Volume Control**: Adjustable sound levels with preview
- **Session Integration**: Sounds automatically play during study sessions

## 🏗️ Technical Architecture

### Architecture Pattern
- **Pattern**: Clean Architecture with MVVM pattern
- **State Management**: Provider pattern for reactive state management
- **Database**: SQLite for local data storage
- **API Integration**: YouTube Data API v3, Google Gemini AI

### Platform Support
- **Cross-Platform**: iOS, Android, Windows, macOS, Linux, Web
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Accessibility**: Full accessibility support with screen reader compatibility

### Key Dependencies
```yaml
dependencies:
  flutter: ^3.0.0
  provider: ^6.0.0                    # State management
  sqflite: ^2.0.0                     # Local database
  youtube_player_flutter: ^8.0.0      # Video playback
  google_generative_ai: ^0.2.0         # AI features
  fl_chart: ^0.65.0                   # Analytics visualization
  webview_flutter: ^4.0.0             # Office suite integration
  file_picker: ^5.0.0                 # File management
  flutter_pdfview: ^1.3.2             # PDF viewing
```

## 📋 Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git

## 🛠️ Installation

### 1. Clone the repository
```bash
git clone https://github.com/leothedev0705/Classify_Final.git
cd Classify_Final
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure API Keys

Create or update `lib/constants/api_keys.dart`:

```dart
class ApiKeys {
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
}
```

#### YouTube API Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable YouTube Data API v3
4. Create credentials (API Key)
5. Add your API key to `lib/constants/api_keys.dart`

#### Gemini AI Setup
1. Go to [Google AI Studio](https://makersuite.google.com/)
2. Create a new API key
3. Add your API key to `lib/constants/api_keys.dart`

### 4. Run the app
```bash
# For mobile
flutter run

# For web
flutter run -d chrome

# For desktop (Windows)
flutter run -d windows
```

## 📁 Project Structure

```
lib/
├── constants/          # App constants and API keys
│   ├── api_keys.dart
│   └── app_constants.dart
├── models/            # Data models and entities
│   ├── achievement.dart
│   ├── quiz.dart
│   ├── study_session.dart
│   ├── user_file.dart
│   └── video.dart
├── providers/         # State management providers
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   ├── chat_provider.dart
│   ├── file_provider.dart
│   ├── quiz_provider.dart
│   ├── schedule_provider.dart
│   ├── study_session_provider.dart
│   └── youtube_provider.dart
├── services/          # API services and business logic
│   ├── achievement_service.dart
│   ├── chat_service.dart
│   ├── database_service.dart
│   ├── file_service.dart
│   ├── quiz_service.dart
│   └── youtube_service.dart
├── screens/          # UI screens and pages
│   ├── dashboard_screen.dart
│   ├── file_manager_screen.dart
│   ├── home_screen.dart
│   ├── kiosk_mode_screen.dart
│   ├── login_screen.dart
│   ├── quiz_screen.dart
│   ├── schedule_screen.dart
│   ├── study_session_screen.dart
│   └── youtube_screen.dart
├── widgets/          # Reusable UI components
│   ├── dashboard_content.dart
│   ├── file_card.dart
│   ├── folder_card.dart
│   └── ...
├── themes/           # App themes
│   └── app_theme.dart
├── utils/            # Helper functions and utilities
│   ├── webview_init.dart
│   └── webview_init_stub.dart
└── main.dart         # App entry point
```

## 🎯 Key Features Implementation

### Study Session Management
- **Timer System**: Real-time countdown with progress visualization
- **Technique Support**: Multiple study methods with customizable durations
- **Kiosk Mode**: Full-screen study environment with distraction blocking
- **Task Integration**: Add and complete tasks during sessions

### AI Integration
- **Quiz Generation**: AI-powered quiz creation based on topics
- **Content Summarization**: Video content analysis and summarization
- **Schedule Optimization**: AI-driven study schedule generation
- **Educational Chat**: Smart assistant for academic queries

### Data Management
- **Local Storage**: SQLite database for offline functionality
- **File Organization**: Subject-wise folder structure
- **Privacy**: All data stored locally, no cloud dependency

## 🧪 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google for YouTube Data API and Gemini AI
- Open source community for various packages
- Contributors and testers

## 📧 Support

For support, email support@classify.app or open an issue on GitHub.

## 🗺️ Roadmap

- [ ] Offline quiz storage
- [ ] Advanced analytics
- [ ] Social features
- [ ] Mobile app optimization
- [ ] Desktop app enhancements
- [ ] Plugin system
- [ ] Advanced AI features
- [ ] Multi-language support
- [ ] Cloud sync
- [ ] Team collaboration features

---

**Classify** - Empowering students with AI-driven study tools and productivity features.

Made with ❤️ using Flutter
