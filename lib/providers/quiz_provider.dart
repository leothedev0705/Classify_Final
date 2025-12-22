import 'package:flutter/material.dart';
import 'package:studex_flutter/models/quiz.dart';

class QuizProvider extends ChangeNotifier {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController chapterController = TextEditingController();
  
  String _selectedDifficulty = '';
  int _questionCount = 10;
  bool _isGenerating = false;
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isCardFlipped = false;
  int _score = 0;

  String get selectedDifficulty => _selectedDifficulty;
  int get questionCount => _questionCount;
  bool get isGenerating => _isGenerating;
  List<Map<String, dynamic>> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isCardFlipped => _isCardFlipped;
  int get score => _score;

  bool get canProceed => _selectedAnswerIndex != null;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  void selectDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setQuestionCount(int count) {
    _questionCount = count;
    notifyListeners();
  }

  Future<void> generateQuiz() async {
    if (topicController.text.isEmpty || chapterController.text.isEmpty || _selectedDifficulty.isEmpty) {
      return;
    }

    _isGenerating = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(Duration(seconds: 3));

    // Generate mock questions
    _questions = List.generate(_questionCount, (index) {
      return {
        'question': 'Sample question ${index + 1} about ${topicController.text}?',
        'options': [
          'Option A',
          'Option B',
          'Option C',
          'Option D',
        ],
        'correctAnswer': index % 4,
        'explanation': 'This is the explanation for question ${index + 1}',
      };
    });

    _isGenerating = false;
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _isCardFlipped = false;
    _score = 0;
    notifyListeners();
  }

  void selectAnswer(int index) {
    _selectedAnswerIndex = index;
    notifyListeners();
  }

  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  void nextQuestion() {
    if (_selectedAnswerIndex != null) {
      // Check if answer is correct
      final question = _questions[_currentQuestionIndex];
      if (_selectedAnswerIndex == question['correctAnswer']) {
        _score += 10;
      }

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isCardFlipped = false;
      }
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _selectedAnswerIndex = null;
      _isCardFlipped = false;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _isCardFlipped = false;
    _score = 0;
    topicController.clear();
    chapterController.clear();
    _selectedDifficulty = '';
    notifyListeners();
  }

  // Missing methods for compatibility
  Future<void> initialize() async {
    // Initialize quiz provider
  }

  Quiz? get currentQuiz => _questions.isNotEmpty ? Quiz(
    topic: topicController.text,
    subtopic: chapterController.text,
    difficulty: _selectedDifficulty,
    questionCount: _questions.length,
    questions: _questions.map((q) => QuizQuestion(
      question: q['question'],
      options: List<String>.from(q['options']),
      correctAnswerIndex: q['correctAnswer'],
      explanation: q['explanation'] ?? 'Explanation for this question',
    )).toList(),
  ) : null;

  List<Quiz> get quizzes => []; // Return empty list for now

  QuizQuestion? get currentQuestion => _questions.isNotEmpty && _currentQuestionIndex < _questions.length
      ? QuizQuestion(
          question: _questions[_currentQuestionIndex]['question'],
          options: List<String>.from(_questions[_currentQuestionIndex]['options']),
          correctAnswerIndex: _questions[_currentQuestionIndex]['correctAnswer'],
          explanation: _questions[_currentQuestionIndex]['explanation'] ?? 'Explanation',
        )
      : null;

  bool get isFirstQuestion => _currentQuestionIndex == 0;

  void startQuiz(Quiz quiz) {
    _questions = quiz.questions.map((q) => {
      'question': q.question,
      'options': q.options,
      'correctAnswer': q.correctAnswerIndex,
      'explanation': q.explanation,
    }).toList();
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _score = 0;
    _isCardFlipped = false;
    notifyListeners();
  }

  void answerQuestion(int answerIndex) {
    _selectedAnswerIndex = answerIndex;
    if (answerIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
      _score += 10;
    }
    notifyListeners();
  }

  void completeQuiz() {
    _isCardFlipped = true;
    notifyListeners();
  }

  void retryQuiz() {
    resetQuiz();
  }

  void resetCurrentQuiz() {
    resetQuiz();
  }
}
