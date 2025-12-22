import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/auth_provider.dart';
import '../providers/study_session_provider.dart';

class TopBar extends StatelessWidget {
  static const Color primaryBlue = Color(0xFF353E6C);
  static const Color bgColor = Color(0xFFEDEEF2);
  static const Color dividerGrey = Color(0xFFD0D0D0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
          bottom: BorderSide(color: dividerGrey, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Study Session Timer (if active)
            Consumer<StudySessionProvider>(
              builder: (context, studyProvider, child) {
                if (studyProvider.isKioskMode && studyProvider.isRunning) {
                  return _buildStudyTimer(context, studyProvider);
                }
                return const SizedBox.shrink();
              },
            ),
            const Spacer(),
            // Top Bar Actions
            _buildTopBarActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarActions(BuildContext context) {
    return Row(
      children: [
        // Clock Button
        _buildActionButton(Iconsax.clock, () {}),
        _buildDivider(),
        // Calendar Button
        _buildActionButton(Iconsax.calendar, () {}),
        _buildDivider(),
        // Profile Dropdown
        _buildProfileDropdown(context),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 36,
      width: 1,
      color: dividerGrey,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: primaryBlue,
          size: 22,
        ),
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildProfileDropdown(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userName = authProvider.user?['name'] ?? 'Luziana';
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.user,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                userName,
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                color: primaryBlue,
                size: 18,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudyTimer(BuildContext context, StudySessionProvider studyProvider) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF21A366),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF21A366).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            studyProvider.isPaused ? Icons.pause_circle_outline : Icons.timer,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            studyProvider.formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 8),
          // Pause/Resume button
          GestureDetector(
            onTap: () => studyProvider.togglePause(),
            child: Icon(
              studyProvider.isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          // Stop button
          GestureDetector(
            onTap: () => _showStopDialog(context, studyProvider),
            child: const Icon(
              Icons.stop,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showStopDialog(BuildContext context, StudySessionProvider studyProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'End Study Session?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to end this study session?',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              studyProvider.endSession();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'End Session',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
