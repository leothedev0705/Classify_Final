import 'package:flutter/material.dart';
// Conditional import for dart:io
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class FolderCard extends StatelessWidget {
  final Directory folder;
  final bool isSelected;
  final VoidCallback onTap;

  const FolderCard({
    Key? key,
    required this.folder,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF353E6C) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.folder,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  folder.path.split('/').last,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
