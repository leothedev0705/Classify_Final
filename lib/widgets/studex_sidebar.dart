import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class StuDexSidebar extends StatefulWidget {
  final Function(int) onItemSelected;
  const StuDexSidebar({super.key, required this.onItemSelected});

  @override
  State<StuDexSidebar> createState() => _StuDexSidebarState();
}

class _StuDexSidebarState extends State<StuDexSidebar> {
  int selectedIndex = 0;
  bool isExpanded = true;

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Iconsax.element_4, 'label': 'Dashboard'},
    {'icon': Iconsax.clock, 'label': 'Study Session'},
    {'icon': Iconsax.video_play, 'label': 'EduTube'},
    {'icon': Iconsax.message, 'label': 'EduBot'},
    {'icon': Iconsax.activity, 'label': 'Result Analysis'},
    {'icon': Iconsax.folder, 'label': 'File Explorer'},
    {'icon': Iconsax.calendar, 'label': 'Schedule'},
    {'icon': Iconsax.note_1, 'label': 'Quizzes'},
    {'icon': Iconsax.setting_2, 'label': 'Tools'},
  ];

  static const Color leftCol = Color(0xFF5B74D8);
  static const Color rightCol = Color(0xFF3E54A0);
  static const Color pillBlue = Color(0xFF3E54A0);
  static const Color pillActiveBg = Color(0xFFEDEEF2); // changed from white to off-white
  static const Color pillActiveText = Color(0xFF3E54A0);
  static const double iconColWidth = 62;
  static const double rowHeight = 54;
  static const double sidebarWidth = 320;
  static const double logoHeight = 80;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded ? sidebarWidth : iconColWidth,
      child: Stack(
        children: [
          // RIGHT COLUMN (text background) - Behind col1
          if (isExpanded)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: sidebarWidth,
                decoration: const BoxDecoration(
                  color: rightCol,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    // Space for col1
                    SizedBox(width: iconColWidth),
                    // Col2 content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          // Close button at top right
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white, size: 22),
                              onPressed: () {
                                setState(() => isExpanded = false);
                              },
                              padding: EdgeInsets.all(12),
                              constraints: BoxConstraints(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // LOGO TEXT - centered
                          SizedBox(
                            height: logoHeight - 28,
                            child: Center(
                              child: Text(
                                'StuDex',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          ...List.generate(menuItems.length, (index) {
                            final isActive = selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedIndex = index);
                                widget.onItemSelected(index);
                              },
                              child: Container(
                                height: rowHeight,
                                alignment: Alignment.centerLeft,
                                decoration: isActive
                                    ? const BoxDecoration(
                                        color: pillActiveBg,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          bottomLeft: Radius.circular(18),
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                        ),
                                      )
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: isActive ? 28 : 25,
                                  ),
                                  child: Text(
                                    menuItems[index]['label'],
                                    style: TextStyle(
                                      color: isActive ? pillActiveText : Colors.white,
                                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                      letterSpacing: 0.1,
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const Spacer(),
                          // Sign Out label with icon
                          Container(
                            height: rowHeight,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // LEFT COLUMN (icons background) - On top of col2
          Container(
            width: iconColWidth,
            decoration: const BoxDecoration(
              color: leftCol,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 28),
                // logo spacing - center aligned icon with expand button
                SizedBox(
                  height: logoHeight,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Iconsax.grid_1,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      if (!isExpanded)
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                setState(() => isExpanded = true);
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ...List.generate(menuItems.length, (index) {
                  final isActive = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                      widget.onItemSelected(index);
                    },
                    child: Container(
                      height: rowHeight,
                      decoration: isActive
                          ? const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            )
                          : null,
                      child: Center(
                        child: Icon(
                          menuItems[index]['icon'],
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                // Sign Out icon
                Container(
                  height: rowHeight,
                  child: Center(
                    child: Icon(Iconsax.logout, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
