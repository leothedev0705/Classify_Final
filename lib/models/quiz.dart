import 'package:uuid/uuid.dart';

class Quiz {
  final String id;
  final String topic;
  final String subtopic;
  final String difficulty;
  final int questionCount;
  final List<QuizQuestion> questions;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int? score;
  final bool isCompleted;

  Quiz({
    String? id,
    required this.topic,
    required this.subtopic,
    required this.difficulty,
    required this.questionCount,
    this.questions = const [],
    DateTime? createdAt,
    this.completedAt,
    this.score,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'subtopic': subtopic,
      'difficulty': difficulty,
      'question_count': questionCount,
      'questions': questions.map((q) => q.toMap()).toList(),
      'created_at': createdAt.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
      'score': score,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'],
      topic: map['topic'],
      subtopic: map['subtopic'],
      difficulty: map['difficulty'],
      questionCount: map['question_count'],
      questions: (map['questions'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromMap(q))
          .toList() ?? [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'])
          : null,
      score: map['score'],
      isCompleted: map['is_completed'] == 1,
    );
  }

  Quiz copyWith({
    String? topic,
    String? subtopic,
    String? difficulty,
    int? questionCount,
    List<QuizQuestion>? questions,
    DateTime? createdAt,
    DateTime? completedAt,
    int? score,
    bool? isCompleted,
  }) {
    return Quiz(
      id: id,
      topic: topic ?? this.topic,
      subtopic: subtopic ?? this.subtopic,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progress {
    if (questions.isEmpty) return 0.0;
    final answeredQuestions = questions.where((q) => q.selectedAnswer != null).length;
    return answeredQuestions / questions.length;
  }

  int get correctAnswers {
    return questions.where((q) => q.isCorrect).length;
  }

  double get accuracy {
    if (questions.isEmpty) return 0.0;
    return correctAnswers / questions.length;
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final int? selectedAnswerIndex;
  final bool isAnswered;

  QuizQuestion({
    String? id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.selectedAnswerIndex,
    this.isAnswered = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer_index': correctAnswerIndex,
      'explanation': explanation,
      'selected_answer_index': selectedAnswerIndex,
      'is_answered': isAnswered ? 1 : 0,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'],
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswerIndex: map['correct_answer_index'],
      explanation: map['explanation'],
      selectedAnswerIndex: map['selected_answer_index'],
      isAnswered: map['is_answered'] == 1,
    );
  }

  QuizQuestion copyWith({
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    int? selectedAnswerIndex,
    bool? isAnswered,
  }) {
    return QuizQuestion(
      id: id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  String? get selectedAnswer {
    if (selectedAnswerIndex == null) return null;
    return options[selectedAnswerIndex!];
  }

  bool get isCorrect {
    if (selectedAnswerIndex == null) return false;
    return selectedAnswerIndex == correctAnswerIndex;
  }
}
