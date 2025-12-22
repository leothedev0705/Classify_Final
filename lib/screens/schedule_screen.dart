import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/schedule_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  final List<String> _fixedActivities = [];
  final TextEditingController _activityController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Schedule Generator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              _showImageUploadDialog();
            },
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, scheduleProvider, child) {
          if (scheduleProvider.isGenerating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating your personalized schedule...'),
                ],
              ),
            );
          }

          if (scheduleProvider.currentSchedule != null) {
            return _buildScheduleView(scheduleProvider);
          }

          return _buildScheduleGenerator(scheduleProvider);
        },
      ),
    );
  }

  Widget _buildScheduleGenerator(ScheduleProvider scheduleProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Schedule Generator Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate Study Schedule',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tasks Section
                  Text(
                    'Study Tasks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTasksSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Date Range
                  Text(
                    'Date Range',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          'Start Date',
                          _startDate,
                          (date) => setState(() => _startDate = date),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateSelector(
                          'End Date',
                          _endDate,
                          (date) => setState(() => _endDate = date),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Fixed Activities
                  Text(
                    'Fixed Activities',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFixedActivitiesSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        _generateSchedule(scheduleProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Generate Schedule',
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
          
          // Recent Schedules
          if (scheduleProvider.schedules.isNotEmpty) ...[
            Text(
              'Recent Schedules',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...scheduleProvider.schedules.take(3).map((schedule) => _buildScheduleCard(schedule, scheduleProvider)),
          ],
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
                  hintText: 'Add a study task...',
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

  Widget _buildDateSelector(String label, DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedActivitiesSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _activityController,
                decoration: const InputDecoration(
                  hintText: 'Add a fixed activity...',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (_activityController.text.isNotEmpty) {
                  setState(() {
                    _fixedActivities.add(_activityController.text);
                    _activityController.clear();
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
        if (_fixedActivities.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._fixedActivities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
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
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _fixedActivities.removeAt(index);
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

  Widget _buildScheduleCard(dynamic schedule, ScheduleProvider scheduleProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(schedule.title),
        subtitle: Text('${schedule.startDate.day}/${schedule.startDate.month} - ${schedule.endDate.day}/${schedule.endDate.month}'),
        trailing: IconButton(
          onPressed: () {
            scheduleProvider.setCurrentSchedule(schedule);
          },
          icon: const Icon(Icons.visibility),
        ),
        onTap: () {
          scheduleProvider.setCurrentSchedule(schedule);
        },
      ),
    );
  }

  Widget _buildScheduleView(ScheduleProvider scheduleProvider) {
    final schedule = scheduleProvider.currentSchedule!;
    
    return Column(
      children: [
        // Schedule Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text(
                schedule.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                schedule.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
        
        // Schedule Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Export schedule
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          scheduleProvider.clearCurrentSchedule();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Schedule Display
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text(
                        'Schedule visualization will be implemented here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generateSchedule(ScheduleProvider scheduleProvider) {
    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one study task')),
      );
      return;
    }

    scheduleProvider.generateSchedule(
      tasks: _tasks,
      startDate: _startDate,
      endDate: _endDate,
      fixedActivities: _fixedActivities,
      preferences: {
        'study_duration': 25,
        'break_duration': 5,
        'preferred_times': ['morning', 'afternoon'],
      },
    );
  }

  void _showImageUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Exam Timetable'),
        content: const Text('This feature will allow you to upload an image of your exam timetable and generate a study schedule based on it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement image upload logic
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
