import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/quiz_provider.dart';
import 'package:studex_flutter/constants/app_constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _subtopicController = TextEditingController();
  String _selectedDifficulty = 'medium';
  int _questionCount = 10;

  @override
  void dispose() {
    _topicController.dispose();
    _subtopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Generator'),
        centerTitle: true,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.currentQuiz != null) {
            return _buildQuizInterface(quizProvider);
          } else {
            return _buildQuizGenerator(quizProvider);
          }
        },
      ),
    );
  }

  Widget _buildQuizGenerator(QuizProvider quizProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Generator Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate New Quiz',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Topic Input
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      labelText: 'Topic',
                      hintText: 'e.g., Mathematics, Science, History',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Subtopic Input
                  TextField(
                    controller: _subtopicController,
                    decoration: const InputDecoration(
                      labelText: 'Subtopic/Chapter',
                      hintText: 'e.g., Algebra, Photosynthesis, World War II',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Difficulty Selection
                  Text(
                    'Difficulty Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AppConstants.difficultyLevels.entries.map((entry) {
                      final isSelected = _selectedDifficulty == entry.key;
                      return FilterChip(
                        label: Text(entry.value),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDifficulty = entry.key;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Question Count
                  Text(
                    'Number of Questions: $_questionCount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _questionCount.toDouble(),
                    min: 5,
                    max: 20,
                    divisions: 15,
                    onChanged: (value) {
                      setState(() {
                        _questionCount = value.round();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: quizProvider.isGenerating ? null : () {
                        _generateQuiz(quizProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: quizProvider.isGenerating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Generate Quiz',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Recent Quizzes
          if (quizProvider.quizzes.isNotEmpty) ...[
            Text(
              'Recent Quizzes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...quizProvider.quizzes.take(5).map((quiz) => _buildQuizCard(quiz, quizProvider)),
          ],
        ],
      ),
    );
  }

  Widget _buildQuizCard(dynamic quiz, QuizProvider quizProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.quiz,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(quiz.topic),
        subtitle: Text('${quiz.difficulty} • ${quiz.questions.length} questions'),
        trailing: quiz.isCompleted
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.primary,
              ),
        onTap: () {
          quizProvider.startQuiz(quiz);
        },
      ),
    );
  }

  Widget _buildQuizInterface(QuizProvider quizProvider) {
    final quiz = quizProvider.currentQuiz!;
    final currentQuestion = quizProvider.currentQuestion;
    
    if (currentQuestion == null) {
      return _buildQuizResults(quizProvider);
    }
    
    return Column(
      children: [
        // Progress Bar
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${quizProvider.currentQuestionIndex + 1} of ${quiz.questions.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(quizProvider.currentQuestionIndex + 1 / quiz.questions.length * 100).round()}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (quizProvider.currentQuestionIndex + 1) / quiz.questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        
        // Question
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Question Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Answer Options
                ...currentQuestion.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = currentQuestion.selectedAnswerIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        quizProvider.answerQuestion(index);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        
        // Navigation Buttons
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              if (!quizProvider.isFirstQuestion)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      quizProvider.previousQuestion();
                    },
                    child: const Text('Previous'),
                  ),
                ),
              if (!quizProvider.isFirstQuestion) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: quizProvider.isLastQuestion
                      ? () {
                          quizProvider.completeQuiz();
                        }
                      : () {
                          quizProvider.nextQuestion();
                        },
                  child: Text(quizProvider.isLastQuestion ? 'Finish Quiz' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResults(QuizProvider quizProvider) {
    final quiz = quizProvider.currentQuiz!;
    final score = quiz.correctAnswers;
    final total = quiz.questions.length;
    final percentage = (score / total * 100).round();
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Score Display
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    '$score / $total',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            _getScoreMessage(percentage),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Great job! You completed the quiz on ${quiz.topic}.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    quizProvider.retryQuiz();
                  },
                  child: const Text('Retry Quiz'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    quizProvider.resetCurrentQuiz();
                  },
                  child: const Text('New Quiz'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int percentage) {
    if (percentage >= 90) return 'Excellent! 🎉';
    if (percentage >= 80) return 'Great job! 👏';
    if (percentage >= 70) return 'Good work! 👍';
    if (percentage >= 60) return 'Not bad! 💪';
    return 'Keep studying! 📚';
  }

  void _generateQuiz(QuizProvider quizProvider) {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic')),
      );
      return;
    }
    
    // Set the values in the provider and generate quiz
    quizProvider.topicController.text = _topicController.text;
    quizProvider.chapterController.text = _subtopicController.text;
    quizProvider.selectDifficulty(_selectedDifficulty);
    quizProvider.setQuestionCount(_questionCount);
    quizProvider.generateQuiz();
  }
}
