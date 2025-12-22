import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'TopMostInfoBox/top_most_info_box.dart';

class QuizContent extends StatefulWidget {
  const QuizContent({Key? key}) : super(key: key);

  @override
  _QuizContentState createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopMostInfoBox(
            title: 'AI-Powered Quiz Generator',
            subtitle: 'Create tailored quizzes from any topic in seconds.',
            imageAsset: 'assets/images/home-girl.png',
          ),
          const SizedBox(height: 24),
          Consumer<QuizProvider>(
            builder: (context, quiz, _) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic
                    const Text(
                      'Enter Educational Topic',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: quiz.topicController,
                      hintText: 'e.g., World War II, Photosynthesis, Quantum Physics',
                    ),
                    const SizedBox(height: 24),

                    // Chapter / Topic
                    const Text(
                      'Chapter/Topic',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: quiz.chapterController,
                      hintText: 'e.g., Chapter 3: Trigonometry',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Specify the chapter or subtopic within the subject',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Difficulty
                    const Text(
                      'Select Difficulty Level',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildDifficultyCard(
                          title: 'Easy',
                          icon: Icons.spa,
                          color: const Color(0xFF10B981),
                          isSelected: quiz.selectedDifficulty == 'easy',
                          onTap: () => quiz.selectDifficulty('easy'),
                        ),
                        _buildDifficultyCard(
                          title: 'Medium',
                          icon: Icons.park,
                          color: const Color(0xFFF59E0B),
                          isSelected: quiz.selectedDifficulty == 'medium',
                          onTap: () => quiz.selectDifficulty('medium'),
                        ),
                        _buildDifficultyCard(
                          title: 'Hard',
                          icon: Icons.terrain,
                          color: const Color(0xFFEF4444),
                          isSelected: quiz.selectedDifficulty == 'hard',
                          onTap: () => quiz.selectDifficulty('hard'),
                        ),
                        _buildDifficultyCard(
                          title: 'Prodigy',
                          icon: Icons.workspace_premium,
                          color: const Color(0xFF8B5CF6),
                          isSelected: quiz.selectedDifficulty == 'prodigy',
                          onTap: () => quiz.selectDifficulty('prodigy'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Question Count slider
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Number of Questions',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Slider(
                            value: quiz.questionCount.toDouble(),
                            min: 5,
                            max: 30,
                            divisions: 25,
                            activeColor: const Color(0xFF3B82F6),
                            onChanged: (v) => quiz.setQuestionCount(v.round()),
                          ),
                          Text(
                            '${quiz.questionCount} questions',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: quiz.isGenerating
                            ? null
                            : () async {
                                await quiz.generateQuiz();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Quiz generated! Open the Quiz section to attempt.')),
                                  );
                                }
                              },
                        icon: const Icon(Icons.edit),
                        label: Text(
                          quiz.isGenerating ? 'Generating...' : 'Generate Quiz',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String hintText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF6B7280),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDifficultyCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
