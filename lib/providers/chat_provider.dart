import 'package:flutter/material.dart';
import 'package:studex_flutter/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<Map<String, dynamic>> _messages = [];
  bool _isDisabled = false;
  int _warningCount = 0;
  int _timeLeft = 0;
  bool _isTimerActive = false;
  bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isDisabled => _isDisabled;
  int get warningCount => _warningCount;
  int get timeLeft => _timeLeft;
  bool get isTimerActive => _isTimerActive;
  bool get isLoading => _isLoading;

  String get formattedTimeLeft {
    final minutes = _timeLeft ~/ 60;
    final seconds = _timeLeft % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  ChatProvider() {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add({
      'sender': 'assistant',
      'text': 'Hello! I\'m your educational assistant. Ask me any educational questions!',
      'isWarning': false,
    });
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    // Add user message
    _messages.add({
      'sender': 'user',
      'text': message,
      'isWarning': false,
    });
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Check if message is educational
      if (_chatService.isEducationalMessage(message)) {
        await _addEducationalResponse(message);
      } else {
        _handleNonEducationalMessage();
      }
    } catch (e) {
      _messages.add({
        'sender': 'assistant',
        'text': 'I apologize, but I encountered an error while processing your request. Please try again.',
        'isWarning': false,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _addEducationalResponse(String message) async {
    try {
      final response = await _chatService.generateEducationalResponse(message);
      _messages.add({
        'sender': 'assistant',
        'text': response,
        'isWarning': false,
      });
    } catch (e) {
      _messages.add({
        'sender': 'assistant',
        'text': 'I apologize, but I couldn\'t generate a response at this time. Please try again.',
        'isWarning': false,
      });
    }
  }

  void _handleNonEducationalMessage() {
    _warningCount++;
    
    if (_warningCount >= 3) {
      _disableChat();
    } else {
      _messages.add({
        'sender': 'assistant',
        'text': _chatService.getNonEducationalWarning(),
        'isWarning': true,
      });
    }
  }


  void _disableChat() {
    _isDisabled = true;
    _timeLeft = 5 * 60; // 5 minutes
    _startTimer();
    
    _messages.add({
      'sender': 'assistant',
      'text': 'I see we need a little break to refocus. Let\'s take 5 minutes to remember why we\'re here - to learn and grow! When we resume, I\'ll be happy to help you with any educational questions.',
      'isWarning': true,
    });
    
    notifyListeners();
  }

  void _startTimer() {
    _isTimerActive = true;
    _timerTick();
  }

  void _timerTick() {
    if (_timeLeft > 0) {
      Future.delayed(Duration(seconds: 1), () {
        _timeLeft--;
        notifyListeners();
        _timerTick();
      });
    } else {
      _enableChat();
    }
  }

  void _enableChat() {
    _isDisabled = false;
    _isTimerActive = false;
    _warningCount = 0;
    _timeLeft = 0;
    
    _messages.add({
      'sender': 'assistant',
      'text': 'Welcome back! I hope you\'re ready to focus on learning. What educational topic would you like to explore?',
      'isWarning': false,
    });
    
    notifyListeners();
  }

  void closeChat() {
    // Handle chat close
  }

  // Initialize method for compatibility
  Future<void> initialize() async {
    // Initialize chat service if needed
  }
}
