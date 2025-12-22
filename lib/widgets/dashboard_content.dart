import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_session_provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';

class DashboardContent extends StatelessWidget {
  static const Color primaryBlue = Color(0xFF353E6C);

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudySessionProvider, AuthProvider>(
      builder: (context, provider, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildWelcomeBanner(authProvider),
              const SizedBox(height: 24),
              _buildDashboardGrid(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeBanner(AuthProvider authProvider) {
    final userName = authProvider.user?['name'] ?? 'Luzianaa';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200, // keep overall box height similar to previous
        child: Stack(
          children: [
            // Decorative shapes - bottom left (filled circle and arc)
            Positioned(
              left: -50,
              bottom: -110,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4EBFF),
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            Positioned(
              left: 30,
              bottom: -100,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD6FF), width: 3),
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.transparent,
                ),
              ),
            ),

            // Decorative shapes - top right (arc and filled circle)
            Positioned(
              right: -30,
              top: -80,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4EBFF),
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
            ),
            Positioned(
              right: 50,
              top: -60,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCBD6FF), width: 3),
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.transparent,
                ),
              ),
            ),

            // Text content - top-left
            Positioned(
              left: 28,
              top: 20,
              right: 260, // leave room for the image
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome back, $userName!',
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 32, // slightly larger
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"One day, all your hard work will pay off."',
                    style: TextStyle(
                      color: Color(0xFF6B7192),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Girl illustration - bottom aligned, larger, no bottom gap
            Positioned(
              right: 100,
              bottom: 0,
              child: SizedBox(
                height: 230, // fill the banner height
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/home-girl.png',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardCard(
          'Quick Links',
          Icons.link,
          'Access your most used features',
          Colors.blue,
        ),
        _buildDashboardCard(
          'Recent Activity',
          Icons.history,
          'View your recent study sessions',
          Colors.green,
        ),
        _buildDashboardCard(
          'Upcoming Tasks',
          Icons.task_alt,
          'Tasks scheduled for today',
          Colors.orange,
        ),
        _buildDashboardCard(
          'Statistics',
          Icons.analytics,
          'Your study progress and insights',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, String description, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryBlue,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7192),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
