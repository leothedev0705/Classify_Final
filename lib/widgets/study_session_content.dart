import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_session_provider.dart';
import '../themes/app_theme.dart';
import 'TopMostInfoBox/top_most_info_box.dart';
import '../screens/kiosk_mode_screen.dart';

class StudySessionContent extends StatefulWidget {
  const StudySessionContent({Key? key}) : super(key: key);

  @override
  _StudySessionContentState createState() => _StudySessionContentState();
}

class _StudySessionContentState extends State<StudySessionContent> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final List<_TaskItem> tasks = [];

  // 🎯 Each technique gets its own hours
  int pomodoroHours = 2;
  int flowHours = 1;
  int timeBlockHours = 3;
  int deepFocusHours = 2;

  String selectedSound = 'None';
  String? _selectedTechnique; // Track which technique card is selected

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopMostInfoBox(
            title: 'Plan your perfect session',
            subtitle: 'Choose a technique and get focused.',
            imageAsset: 'assets/images/StudySeshChar.png',
          ),
          const SizedBox(height: 24),
          _buildSetupSection(),
        ],
      ),
    );
  }

  Widget _buildSetupSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Set Up Your Study Session',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Choose Study Technique'),
          const SizedBox(height: 20),
          _buildTechniqueGrid(),
          const SizedBox(height: 28),
          _sectionHeader('Session Tasks'),
          const SizedBox(height: 12),
          _buildTaskInputContainer(),
          const SizedBox(height: 16),
          ...tasks.map((t) => _taskRow(t)).toList(),
          const SizedBox(height: 28),
          _sectionHeader('Ambient Sounds'),
          const SizedBox(height: 12),
          _ambientSoundsRow(),
          const SizedBox(height: 28),
          _sectionHeader('Session Title'),
          const SizedBox(height: 10),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Add Title for Session',
            ),
          ),
          const SizedBox(height: 20),
          _sectionHeader('Session Description'),
          const SizedBox(height: 10),
          TextField(
            controller: descController,
            decoration: const InputDecoration(
              hintText: 'Add Description for Session',
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          _startButton(),
        ],
      ),
    );
  }

  // ✅ Each card has independent hours logic
  Widget _buildTechniqueGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 20;
        const int cardCount = 4;
        final double totalGapWidth = gap * (cardCount - 1);
        final double cardWidth =
            (constraints.maxWidth - totalGapWidth) / cardCount;
        final double cardHeight = 300;

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _TechniqueCard(
              width: cardWidth,
              height: cardHeight,
              title: 'Pomodoro\nTechnique',
              subtitle: '25 min work, 5 min break, repeat',
              duration: '$pomodoroHours hrs',
              color: const Color(0xFFF04D83),
              isSelected: _selectedTechnique == 'pomodoro',
              onAdd: () => setState(() => pomodoroHours++),
              onRemove: () => setState(() {
                if (pomodoroHours > 1) pomodoroHours--;
              }),
              onTap: () => setState(() => _selectedTechnique = 'pomodoro'),
            ),
            const SizedBox(width: gap),
            _TechniqueCard(
              width: cardWidth,
              height: cardHeight,
              title: 'Flow\nMethod',
              subtitle: 'Work deeply for extended focus',
              duration: '$flowHours hrs',
              color: const Color(0xFFF4A24A),
              isSelected: _selectedTechnique == 'flow',
              onAdd: () => setState(() => flowHours++),
              onRemove: () => setState(() {
                if (flowHours > 1) flowHours--;
              }),
              onTap: () => setState(() => _selectedTechnique = 'flow'),
            ),
            const SizedBox(width: gap),
            _TechniqueCard(
              width: cardWidth,
              height: cardHeight,
              title: 'Time Blocking',
              subtitle: 'Segment tasks by time slots',
              duration: '$timeBlockHours hrs',
              color: const Color(0xFF3B2F7E),
              isSelected: _selectedTechnique == 'timeblocking',
              onAdd: () => setState(() => timeBlockHours++),
              onRemove: () => setState(() {
                if (timeBlockHours > 1) timeBlockHours--;
              }),
              onTap: () => setState(() => _selectedTechnique = 'timeblocking'),
            ),
            const SizedBox(width: gap),
            _TechniqueCard(
              width: cardWidth,
              height: cardHeight,
              title: 'Deep Focus',
              subtitle: 'Full immersion, zero distraction',
              duration: '$deepFocusHours hrs',
              color: const Color(0xFF209B95),
              isSelected: _selectedTechnique == 'deepfocus',
              onAdd: () => setState(() => deepFocusHours++),
              onRemove: () => setState(() {
                if (deepFocusHours > 1) deepFocusHours--;
              }),
              onTap: () => setState(() => _selectedTechnique = 'deepfocus'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskInputContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC5C7D0), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: taskController,
              decoration: const InputDecoration(
                hintText: 'Add Tasks for this Session',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          Container(
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF2E3A59),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
            child: TextButton(
              onPressed: _addTask,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    final text = taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(_TaskItem(text));
        taskController.clear();
      });
    }
  }

  Widget _taskRow(_TaskItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: item.done,
            onChanged: (v) => setState(() => item.done = v ?? false),
            activeColor: const Color(0xFF353E6C),
          ),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: item.done
                    ? const Color(0xFF353E6C).withOpacity(0.4)
                    : const Color(0xFF353E6C),
                decoration: item.done ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF353E6C)),
            onPressed: () {
              setState(() {
                tasks.remove(item);
              });
            },
            tooltip: 'Delete task',
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        const Icon(Icons.menu, size: 22, color: Color(0xFF353E6C)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF353E6C),
          ),
        ),
      ],
    );
  }

  Widget _ambientSoundsRow() {
    final sounds = ['None', 'Cafe', 'Rain', 'Nature', 'White Noise'];
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: sounds.map((soundName) {
        final isActive = selectedSound == soundName;
        return InkWell(
          onTap: () => setState(() => selectedSound = soundName),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEF2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF353E6C)
                    : const Color(0xFFB8BED1),
                width: isActive ? 2 : 1,
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: const Color(0xFF353E6C).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.music_note,
                    color: Color(0xFF353E6C), size: 36),
                const SizedBox(height: 10),
                Text(
                  soundName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _startButton() {
    return Consumer<StudySessionProvider>(
      builder: (context, studyProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedTechnique == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a study technique first'),
                    backgroundColor: Color(0xFF353E6C),
                  ),
                );
                return;
              }
              
              // Get the hours for the selected technique
              int hours = 1;
              switch (_selectedTechnique) {
                case 'pomodoro':
                  hours = pomodoroHours;
                  break;
                case 'flow':
                  hours = flowHours;
                  break;
                case 'timeblocking':
                  hours = timeBlockHours;
                  break;
                case 'deepfocus':
                  hours = deepFocusHours;
                  break;
              }
              
              // Set sound and tasks in provider
              studyProvider.selectSound(selectedSound);
              for (var task in tasks) {
                if (!task.done) {
                  studyProvider.addTask(task.label);
                }
              }
              
              // Start the session
              studyProvider.startSession(
                technique: _selectedTechnique,
                durationHours: hours,
              );
              
              // Navigate to kiosk mode screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => KioskModeScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF353E6C),
              foregroundColor: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text(
              'Start Study Session',
              style:
                  TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

class _TechniqueCard extends StatelessWidget {
  const _TechniqueCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.color,
    this.onAdd,
    this.onRemove,
    required this.width,
    required this.height,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String duration;
  final Color color;
  final double width;
  final double height;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Use the same colors as office cards
    Color lightColor;
    Color borderColor;
    Color circleColor;
    
    if (title.contains('Pomodoro')) {
      lightColor = const Color(0xFFFFE0D7);
      borderColor = const Color(0xFFCF4D2A);
      circleColor = const Color(0xFFCF4D2A);
    } else if (title.contains('Flow')) {
      lightColor = const Color(0xFFD0FFE9);
      borderColor = const Color(0xFF21A366);
      circleColor = const Color(0xFF21A366);
    } else if (title.contains('Time Blocking')) {
      lightColor = const Color(0xFFE7F5FF);
      borderColor = const Color(0xFF2B7CD3);
      circleColor = const Color(0xFF2B7CD3);
    } else if (title.contains('Deep Focus')) {
      lightColor = const Color(0xFFFFF6D5);
      borderColor = const Color(0xFFFFB02E);
      circleColor = const Color(0xFFFFB02E);
    } else {
      lightColor = Color.fromRGBO(
        (color.red + 255 * 2) ~/ 3,
        (color.green + 255 * 2) ~/ 3,
        (color.blue + 255 * 2) ~/ 3,
        1.0,
      );
      borderColor = color;
      circleColor = color;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Stack(
              children: [
                // Large decorative circle in top-right corner
                Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: circleColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Smaller decorative circle in bottom-left corner
              Positioned(
                bottom: -15,
                left: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: circleColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: borderColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: borderColor.withOpacity(0.8),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: onRemove,
                            child: const Icon(Icons.remove,
                                size: 18, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onAdd,
                            child: const Icon(Icons.add, size: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _TaskItem {
  _TaskItem(this.label, {this.done = false});
  String label;
  bool done;
}
