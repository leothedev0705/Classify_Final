import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/study_session_provider.dart';
import 'package:studex_flutter/constants/app_constants.dart';
import 'package:studex_flutter/widgets/study_session_widgets.dart';
import 'package:studex_flutter/screens/kiosk_mode_screen.dart';

class StudySessionScreen extends StatefulWidget {
  const StudySessionScreen({super.key});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  String _selectedTechnique = 'pomodoro';
  int _duration = 25;
  int _breakDuration = 5;
  final List<String> _tasks = [];
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  String _selectedAmbientSound = 'rain';

  @override
  void dispose() {
    _notesController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Session'),
        centerTitle: true,
      ),
      body: Consumer<StudySessionProvider>(
        builder: (context, studyProvider, child) {
          if (studyProvider.currentSession != null) {
            return _buildActiveSessionView(studyProvider);
          } else {
            return _buildSessionSetupView();
          }
        },
      ),
    );
  }

  Widget _buildActiveSessionView(StudySessionProvider studyProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Session Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    studyProvider.currentSession!.technique,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    studyProvider.isBreak ? 'Break Time' : 'Study Time',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // Timer Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular Progress
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(
                            value: studyProvider.progress,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  studyProvider.formattedTimeRemaining,
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                  ),
                                ),
                                Text(
                                  studyProvider.isBreak ? 'Break' : 'Study',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            studyProvider.togglePause();
                          },
                          backgroundColor: Colors.white,
                          child: Icon(
                            studyProvider.isRunning ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 20),
                        FloatingActionButton(
                          onPressed: () {
                            _showStopSessionDialog(studyProvider);
                          },
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.stop, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Session Details
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  if (studyProvider.currentSession!.tasks.isNotEmpty) ...[
                    Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...studyProvider.currentSession!.tasks.map((task) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                  ],
                  if (studyProvider.currentSession!.notes.isNotEmpty) ...[
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      studyProvider.currentSession!.notes,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionSetupView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Technique Selection
          Text(
            'Select Study Technique',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...AppConstants.studyTechniques.entries.map((entry) {
            final technique = entry.value;
            return _buildTechniqueCard(entry.key, technique);
          }),
          
          const SizedBox(height: 24),
          
          // Duration Settings
          Text(
            'Duration Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDurationSlider('Study Duration', _duration, (value) {
            setState(() {
              _duration = value;
            });
          }),
          _buildDurationSlider('Break Duration', _breakDuration, (value) {
            setState(() {
              _breakDuration = value;
            });
          }),
          
          const SizedBox(height: 24),
          
          // Tasks Section
          Text(
            'Tasks',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTasksSection(),
          
          const SizedBox(height: 24),
          
          // Notes Section
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add any notes for this session...',
              border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Ambient Sound
          Text(
            'Ambient Sound',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildAmbientSoundSelector(),
          
          const SizedBox(height: 32),
          
          // Start Session Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                _startSession();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Study Session',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard(String key, Map<String, dynamic> technique) {
    final isSelected = _selectedTechnique == key;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTechnique = key;
            _duration = technique['duration'];
            _breakDuration = technique['break_duration'];
          });
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
              Text(
                technique['icon'],
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technique['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      technique['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSlider(String title, int value, Function(int) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ${value} minutes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: value.toDouble(),
            min: 5,
            max: 180,
            divisions: 35,
            onChanged: (value) => onChanged(value.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  hintText: 'Add a task...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add(_taskController.text);
                    _taskController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        if (_tasks.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._tasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _tasks.removeAt(index);
                      });
                    },
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildAmbientSoundSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.ambientSounds.entries.map((entry) {
        final isSelected = _selectedAmbientSound == entry.key;
        return FilterChip(
          label: Text(entry.value),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedAmbientSound = entry.key;
            });
          },
        );
      }).toList(),
    );
  }

  void _startSession() {
    final studyProvider = Provider.of<StudySessionProvider>(context, listen: false);
    studyProvider.startSession(
      technique: _selectedTechnique,
      duration: _duration,
      breakDuration: _breakDuration,
      tasks: _tasks,
      notes: _notesController.text,
      ambientSound: _selectedAmbientSound,
    );
    
    // Navigate to kiosk mode screen - this replaces the entire navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const KioskModeScreen(),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  void _showStopSessionDialog(StudySessionProvider studyProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Session'),
        content: const Text('Are you sure you want to stop the current session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              studyProvider.stopSession();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
