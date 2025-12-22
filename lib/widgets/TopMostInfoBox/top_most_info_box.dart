import 'package:flutter/material.dart';

class TopMostInfoBox extends StatelessWidget {
  const TopMostInfoBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    this.height = 200,
    this.primaryBlue = const Color(0xFF353E6C),
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final double height;
  final Color primaryBlue;

  @override
  Widget build(BuildContext context) {
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
        height: height,
        child: Stack(
          children: [
            // Decorative shapes - bottom left
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

            // Decorative shapes - top right
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

            // Text - top-left
            Positioned(
              left: 28,
              top: 20,
              right: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6B7192),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Image - bottom aligned, larger, no bottom gap
            Positioned(
              right: 100,
              bottom: 0,
              child: SizedBox(
                height: height + 30,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    imageAsset,
                    height: height + 100,
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
}
