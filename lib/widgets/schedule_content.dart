import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TopMostInfoBox/top_most_info_box.dart';

class ScheduleContent extends StatefulWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  _ScheduleContentState createState() => _ScheduleContentState();
}

class _ScheduleContentState extends State<ScheduleContent> {
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  List<CalendarEvent> _events = [];
  List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // Sorted events for consistent Upcoming Schedule ordering
  List<CalendarEvent> get _eventsSorted {
    final list = List<CalendarEvent>.from(_events);
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Sample events - using purple color scheme like the image
    _events = [
      CalendarEvent(
        id: '1',
        title: 'ALGEBRA',
        date: DateTime(2024, 9, 5),
        startTime: '04:00PM',
        endTime: '06:00PM',
        color: const Color(0xFF9C27B0), // Dark purple like the image
      ),
      CalendarEvent(
        id: '2',
        title: 'ALGEBRA',
        date: DateTime(2024, 9, 15),
        startTime: '04:00PM',
        endTime: '06:00PM',
        color: const Color(0xFF9C27B0), // Dark purple like the image
      ),
      CalendarEvent(
        id: '3',
        title: 'ALGEBRA',
        date: DateTime(2024, 9, 16),
        startTime: '04:00PM',
        endTime: '06:00PM',
        color: const Color(0xFF9C27B0), // Dark purple like the image
      ),
      CalendarEvent(
        id: '4',
        title: 'ALGEBRA',
        date: DateTime(2024, 9, 16),
        startTime: '04:00PM',
        endTime: '06:00PM',
        color: const Color(0xFF9C27B0), // Dark purple like the image
      ),
      CalendarEvent(
        id: '5',
        title: 'ALGEBRA',
        date: DateTime(2024, 9, 16),
        startTime: '04:00PM',
        endTime: '06:00PM',
        color: const Color(0xFF9C27B0), // Dark purple like the image
      ),
    ];

    // Sample tasks - using study session colors
    _tasks = [
      Task(
        id: '1',
        title: 'MATH',
        day: 'Tue',
        startTime: '8AM',
        endTime: '10AM',
        color: const Color(0xFF2B7CD3), // Time Blocking border color
      ),
      Task(
        id: '2',
        title: 'ALGEBRA',
        day: 'Thurs',
        startTime: '10AM',
        endTime: '12PM',
        color: const Color(0xFFCF4D2A), // Pomodoro border color
      ),
      Task(
        id: '3',
        title: 'ALGEBRA',
        day: 'Sat',
        startTime: '8AM',
        endTime: '10AM',
        color: const Color(0xFF21A366), // Flow border color
      ),
    ];
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _showAddTaskDialog(date);
  }

  void _showAddTaskDialog(DateTime selectedDate) {
    _titleController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task for ${DateFormat('MMM dd, yyyy').format(selectedDate)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Start Time (e.g., 04:00PM)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _endTimeController,
                    decoration: const InputDecoration(
                      labelText: 'End Time (e.g., 06:00PM)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addTaskToCalendar(selectedDate);
              Navigator.of(context).pop();
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  void _addTaskToCalendar(DateTime date) {
    if (_titleController.text.trim().isNotEmpty) {
      final newEvent = CalendarEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim().toUpperCase(),
        date: date,
        startTime: _startTimeController.text.trim().isEmpty ? '04:00PM' : _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim().isEmpty ? '06:00PM' : _endTimeController.text.trim(),
        color: _getRandomStudySessionColor(),
      );
      
      setState(() {
        _events.add(newEvent);
      });
      
      _showSnackBar('Task added successfully!');
    }
  }

  Color _getRandomStudySessionColor() {
    final colors = [
      const Color(0xFFCF4D2A), // Pomodoro
      const Color(0xFF21A366), // Flow
      const Color(0xFF2B7CD3), // Time Blocking
      const Color(0xFFFFB02E), // Deep Focus
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  void _createNewSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  // Handle date selection
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('Schedule created successfully!');
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF353E6C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // TopMost Info Box
          const TopMostInfoBox(
            title: 'Build your perfect plan',
            subtitle: 'Generate smart schedules in minutes.',
            imageAsset: 'assets/images/home-girl.png',
          ),
          const SizedBox(height: 24),
          // Main Calendar Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header with Title and New Schedule Button
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Explore & Organize Files',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF353E6C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _createNewSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('New Schedule'),
                      ),
                    ],
                  ),
                ),
                // Calendar and Side Panels
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calendar Section (Left 2/3)
                      Expanded(
                        flex: 2,
                        child: _buildCalendar(),
                      ),
                      const SizedBox(width: 24),
                      // Side Panels (Right 1/3)
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildUpcomingTasks(),
                            const SizedBox(height: 16),
                            _buildUpcomingSchedule(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    final daysInPreviousMonth = DateTime(_currentDate.year, _currentDate.month, 0).day;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Navigation
        Row(
          children: [
            InkWell(
              onTap: _previousMonth,
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF353E6C),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              DateFormat('MMMM yyyy').format(_currentDate),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: _nextMonth,
              child: const Icon(
                Icons.chevron_right,
                color: Color(0xFF353E6C),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Days of Week Headers
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF353E6C),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar Grid
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              for (int week = 0; week < 6; week++)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: week < 5 
                          ? BorderSide(color: const Color(0xFFE5E7EB))
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    children: [
                      for (int day = 0; day < 7; day++)
                        Expanded(
                          child: _buildCalendarCell(
                            week: week,
                            day: day,
                            firstDayWeekday: firstDayWeekday,
                            daysInMonth: daysInMonth,
                            daysInPreviousMonth: daysInPreviousMonth,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCell({
    required int week,
    required int day,
    required int firstDayWeekday,
    required int daysInMonth,
    required int daysInPreviousMonth,
  }) {
    int dayNumber;
    bool isCurrentMonth = true;
    bool isToday = false;
    bool isSelected = false;
    DateTime? cellDate;

    if (week == 0 && day < firstDayWeekday - 1) {
      // Previous month
      dayNumber = daysInPreviousMonth - (firstDayWeekday - 2 - day);
      isCurrentMonth = false;
    } else if (week * 7 + day - (firstDayWeekday - 1) >= daysInMonth) {
      // Next month
      dayNumber = (week * 7 + day - (firstDayWeekday - 1)) - daysInMonth + 1;
      isCurrentMonth = false;
    } else {
      // Current month
      dayNumber = week * 7 + day - (firstDayWeekday - 1) + 1;
      cellDate = DateTime(_currentDate.year, _currentDate.month, dayNumber);
      isToday = cellDate.day == DateTime.now().day &&
                cellDate.month == DateTime.now().month &&
                cellDate.year == DateTime.now().year;
      isSelected = _selectedDate != null &&
                   cellDate.day == _selectedDate!.day &&
                   cellDate.month == _selectedDate!.month &&
                   cellDate.year == _selectedDate!.year;
    }

    // Get events for this date
    List<CalendarEvent> dayEvents = [];
    if (cellDate != null) {
      dayEvents = _events.where((event) =>
          event.date.year == cellDate!.year &&
          event.date.month == cellDate!.month &&
          event.date.day == cellDate!.day).toList();
    }

    return Container(
      height: 100, // Increased height to accommodate events
      decoration: BoxDecoration(
        border: Border(
          right: day < 6 
              ? BorderSide(color: const Color(0xFFE5E7EB))
              : BorderSide.none,
        ),
        color: isSelected 
            ? const Color(0xFF353E6C)
            : isToday 
                ? const Color(0xFF353E6C).withValues(alpha: 0.1)
                : Colors.white,
      ),
      child: InkWell(
        onTap: isCurrentMonth 
            ? () => _selectDate(DateTime(_currentDate.year, _currentDate.month, dayNumber))
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date number
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? Colors.white
                      : isCurrentMonth 
                          ? const Color(0xFF353E6C)
                          : const Color(0xFF6B7280),
                ),
              ),
            ),
            // Events for this day
            if (dayEvents.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Column(
                    children: dayEvents.take(2).map((event) => Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: event.color.withValues(alpha: 0.14), // light pastel background
                        borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(color: event.color, width: 6), // colored strip
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: event.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${event.startTime}-${event.endTime}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: event.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTasks() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Task',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 16),
          // Timeline Header - exactly like the image
          Row(
            children: [
              const SizedBox(width: 40), // Space for day labels
              const Text(
                '8AM',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 40),
              const Text(
                '10AM',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 40),
              const Text(
                '12PM',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 40),
              const Text(
                '2PM',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tasks List - exactly like the image layout
          ..._tasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              task.day,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF353E6C),
              ),
            ),
          ),
          // Task pill - exactly like the image
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '• ${task.title}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSchedule() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Schedule',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 16),
          ..._eventsSorted.map((event) => _buildScheduleItem(event)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFE0D7FF), // Light purple background like the image
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Thick dark purple vertical strip on left edge
          Container(
            width: 8, // Made thicker like the image
            height: 64,
            margin: const EdgeInsets.symmetric(vertical: 6), // small gaps top & bottom
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0), // Dark purple like the image
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          // White date box with proper padding and gaps
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB), // Light gray border
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6), // tighter padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.date.day.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9C27B0), // Dark purple for day number
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM').format(event.date),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9C27B0), // Dark purple for month
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Event details on the right
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9C27B0), // Dark purple for title
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.startTime}-${event.endTime}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9C27B0), // Dark purple for time
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final Color color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class Task {
  final String id;
  final String title;
  final String day;
  final String startTime;
  final String endTime;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}
