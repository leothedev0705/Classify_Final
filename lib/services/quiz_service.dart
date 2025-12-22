import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:studex_flutter/models/quiz.dart';
import 'package:studex_flutter/constants/app_constants.dart';
import 'package:studex_flutter/constants/api_keys.dart';

class QuizService {
  late GenerativeModel _model;
  bool _isInitialized = false;

  // Initialize the AI model
  Future<void> _initialize() async {
    if (_isInitialized) return;
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: ApiKeys.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    _isInitialized = true;
  }

  // Generate quiz using AI
  Future<Quiz> generateQuiz({
    required String topic,
    required String subtopic,
    required String difficulty,
    required int questionCount,
  }) async {
    await _initialize();

    try {
      final prompt = _buildQuizPrompt(topic, subtopic, difficulty, questionCount);
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      return _parseQuizResponse(text, topic, subtopic, difficulty, questionCount);
    } catch (e) {
      throw Exception('Failed to generate quiz: $e');
    }
  }

  // Build the prompt for quiz generation
  String _buildQuizPrompt(String topic, String subtopic, String difficulty, int questionCount) {
    return '''
Generate a $difficulty level quiz about $topic - $subtopic with $questionCount multiple choice questions.

Each question should have:
- A clear, concise question
- 4 answer options (A, B, C, D)
- Only one correct answer
- A brief explanation for the correct answer

Format the response as JSON with this structure:
{
  "questions": [
    {
      "question": "Question text here",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswerIndex": 0,
      "explanation": "Explanation of why this answer is correct"
    }
  ]
}

Make sure the questions are appropriate for $difficulty level and cover different aspects of $topic - $subtopic.
''';
  }

  // Parse the AI response into a Quiz object
  Quiz _parseQuizResponse(String response, String topic, String subtopic, String difficulty, int questionCount) {
    try {
      // Extract JSON from response (handle markdown formatting)
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception('No valid JSON found in response');
      }
      
      final jsonString = response.substring(jsonStart, jsonEnd);
      
      // Parse JSON (you might want to use dart:convert for this)
      // For now, we'll create a mock quiz
      return _createMockQuiz(topic, subtopic, difficulty, questionCount);
    } catch (e) {
      // Fallback to mock quiz if parsing fails
      return _createMockQuiz(topic, subtopic, difficulty, questionCount);
    }
  }

  // Create a mock quiz for testing (remove this when AI integration is working)
  Quiz _createMockQuiz(String topic, String subtopic, String difficulty, int questionCount) {
    final List<QuizQuestion> questions = [];
    
    for (int i = 0; i < questionCount; i++) {
      questions.add(QuizQuestion(
        question: 'Sample question ${i + 1} about $topic - $subtopic?',
        options: [
          'Option A - Correct answer',
          'Option B - Incorrect',
          'Option C - Incorrect',
          'Option D - Incorrect',
        ],
        correctAnswerIndex: 0,
        explanation: 'This is the correct answer because...',
      ));
    }
    
    return Quiz(
      topic: topic,
      subtopic: subtopic,
      difficulty: difficulty,
      questionCount: questionCount,
      questions: questions,
    );
  }

  // Generate quiz based on study session content
  Future<Quiz> generateQuizFromSession({
    required String sessionNotes,
    required String topic,
    required String difficulty,
    required int questionCount,
  }) async {
    await _initialize();

    try {
      final prompt = '''
Based on these study session notes about $topic:
"$sessionNotes"

Generate a $difficulty level quiz with $questionCount multiple choice questions that test understanding of the concepts covered in these notes.

Format the response as JSON with this structure:
{
  "questions": [
    {
      "question": "Question text here",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswerIndex": 0,
      "explanation": "Explanation of why this answer is correct"
    }
  ]
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      return _parseQuizResponse(text, topic, 'Session Review', difficulty, questionCount);
    } catch (e) {
      throw Exception('Failed to generate quiz from session: $e');
    }
  }

  // Generate quiz from video content
  Future<Quiz> generateQuizFromVideo({
    required String videoTitle,
    required String videoDescription,
    required String topic,
    required String difficulty,
    required int questionCount,
  }) async {
    await _initialize();

    try {
      final prompt = '''
Based on this educational video about $topic:
Title: "$videoTitle"
Description: "$videoDescription"

Generate a $difficulty level quiz with $questionCount multiple choice questions that test understanding of the video content.

Format the response as JSON with this structure:
{
  "questions": [
    {
      "question": "Question text here",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correctAnswerIndex": 0,
      "explanation": "Explanation of why this answer is correct"
    }
  ]
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      return _parseQuizResponse(text, topic, 'Video Content', difficulty, questionCount);
    } catch (e) {
      throw Exception('Failed to generate quiz from video: $e');
    }
  }
}
