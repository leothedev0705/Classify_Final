import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:studex_flutter/constants/api_keys.dart';

class ChatService {
  late GenerativeModel _model;
  bool _isInitialized = false;

  // Initialize the AI model with fallback
  Future<void> _initialize() async {
    if (_isInitialized) return;
    
    // Try modern model first, then fall back to gemini-pro for older SDKs
    final candidates = ['gemini-1.5-flash', 'gemini-pro'];
    Object? lastError;
    for (final name in candidates) {
      try {
        _model = GenerativeModel(
          model: name,
          apiKey: ApiKeys.geminiApiKey,
          generationConfig: GenerationConfig(
            temperature: 0.7,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 512,
          ),
        );
        // quick no-op call to validate
        await _model.generateContent([Content.text('ok')]);
        _isInitialized = true;
        return;
      } catch (e) {
        lastError = e;
        continue;
      }
    }
    // If all models fail, throw last error to be caught by caller
    throw Exception('Gemini init failed: $lastError');
  }

  // Generate educational response using AI
  Future<String> generateEducationalResponse(String message) async {
    await _initialize();

    try {
      final prompt = _buildEducationalPrompt(message);
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        // Retry once with simpler prompt
        final retry = await _model.generateContent([Content.text('Answer this educationally and concisely: $message')]);
        return retry.text ?? 'I apologize, but I couldn\'t generate a response at this time.';
      }
      return text;
    } catch (e) {
      // Reinitialize with fallback once, then retry
      _isInitialized = false;
      try {
        await _initialize();
        final retry = await _model.generateContent([Content.text('Answer this educationally and concisely: $message')]);
        return retry.text ?? 'I apologize, but I couldn\'t generate a response at this time.';
      } catch (_) {
        return 'I\'m sorry, I encountered an error while processing your request. Please try again later.';
      }
    }
  }

  // Build educational prompt
  String _buildEducationalPrompt(String message) {
    return '''
You are an educational assistant (EduBot) designed to help students with their academic questions. 
Your role is to provide clear, accurate, and helpful educational content.

Guidelines:
- Focus on educational topics only
- Provide clear explanations and examples
- Break down complex concepts into understandable parts
- Encourage learning and curiosity
- If asked about non-educational topics, politely redirect to educational subjects

Student's question: $message

Please provide a helpful educational response:
''';
  }

  // Check if message is educational
  bool isEducationalMessage(String message) {
    final educationalKeywords = [
      'math', 'mathematics', 'science', 'physics', 'chemistry', 'biology',
      'history', 'geography', 'literature', 'programming', 'computer',
      'study', 'learn', 'education', 'school', 'college', 'university',
      'question', 'help', 'explain', 'understand', 'concept', 'theory',
      'solve', 'problem', 'homework', 'assignment', 'exam', 'test',
      'formula', 'equation', 'experiment', 'research', 'analysis',
      'grammar', 'writing', 'essay', 'poetry', 'novel', 'story',
      'language', 'vocabulary', 'pronunciation', 'translation',
      'economics', 'politics', 'society', 'culture', 'art', 'music',
      'philosophy', 'psychology', 'sociology', 'anthropology',
      'medicine', 'health', 'anatomy', 'physiology', 'genetics',
      'engineering', 'technology', 'software', 'hardware', 'coding',
      'design', 'architecture', 'environment', 'ecology', 'geology'
    ];

    final lowercaseMessage = message.toLowerCase();
    return educationalKeywords.any((keyword) => lowercaseMessage.contains(keyword));
  }

  // Generate warning message for non-educational content
  String getNonEducationalWarning() {
    return '''I'm an educational assistant focused on helping with academic topics. 
    Please ask me questions about subjects like:
    • Mathematics and Science
    • History and Geography  
    • Literature and Languages
    • Programming and Technology
    • Study techniques and learning strategies
    
    I'm here to help you learn and understand educational concepts!''';
  }
}
