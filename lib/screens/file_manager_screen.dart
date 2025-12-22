import 'package:flutter/material.dart';
import 'dart:io';
import '../services/file_service.dart';
import '../widgets/folder_card.dart';
import 'folder_view_screen.dart';

/// File Manager Screen - Google Drive-like file organization system
/// 
/// TESTING STEPS:
/// 1. Run app, navigate to Tools section, click "Open File Manager"
/// 2. Click "+ Add Category" → create "Physics" folder
/// 3. Open "Physics" folder → Upload one PDF and one TXT file
/// 4. Verify preview works and files appear in list
/// 
/// Features: Folder creation, file upload (PDF/DOC/DOCX/TXT), search, 
/// grid/list views, file preview, rename/delete operations
class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({Key? key}) : super(key: key);

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final FileService _fileService = FileService();
  List<Directory> _folders = [];
  Directory? _selectedFolder;
  bool _isGridView = true;
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final folders = await _fileService.getFolders();
      setState(() {
        _folders = folders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error loading folders: ${e.toString()}');
    }
  }

  List<Map<String, dynamic>> get _defaultCategories => [
    {'name': 'Homework', 'icon': Icons.assignment},
    {'name': 'Notes', 'icon': Icons.note},
    {'name': 'Assignments', 'icon': Icons.assignment_turned_in},
  ];

  Future<void> _createFolder() async {
    final TextEditingController controller = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter folder name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      try {
        await _fileService.createFolder(result.trim());
        await _loadFolders();
        _showSnackBar('Folder created successfully');
      } catch (e) {
        _showSnackBar('Error creating folder: ${e.toString()}');
      }
    }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(20),
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
          child: Row(
            children: [
              // Left Sidebar
              Container(
                width: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Text(
                        'Quick Access',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF353E6C),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildQuickAccessItem(
                            'All Files',
                            Icons.folder,
                            _selectedFolder == null,
                            () => setState(() => _selectedFolder = null),
                          ),
                          _buildQuickAccessItem(
                            'Recent Files',
                            Icons.access_time,
                            false,
                            () {},
                          ),
                          _buildQuickAccessItem(
                            'Documents',
                            Icons.description,
                            false,
                            () {},
                          ),
                          _buildQuickAccessItem(
                            'PDFs',
                            Icons.picture_as_pdf,
                            false,
                            () {},
                          ),
                          _buildQuickAccessItem(
                            'Other Files',
                            Icons.insert_drive_file,
                            false,
                            () {},
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF353E6C),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF353E6C)),
                                ),
                              ),
                            )
                          else ...[
                            // Default categories (always shown)
                            ..._defaultCategories.map(
                              (category) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          category['icon'] as IconData,
                                          color: const Color(0xFF6B7280),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            category['name'] as String,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // User-created folders
                            ..._folders.map(
                              (folder) => FolderCard(
                                folder: folder,
                                isSelected: _selectedFolder?.path == folder.path,
                                onTap: () => setState(() => _selectedFolder = folder),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF21A366),
                            style: BorderStyle.solid,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          onPressed: _createFolder,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Category'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF21A366),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content Area
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
                        child: Column(
                          children: [
                            const Text(
                              'Explore & Organize Files',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF353E6C),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FA),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: TextField(
                                      onChanged: (value) => setState(() => _searchQuery = value),
                                      decoration: const InputDecoration(
                                        hintText: 'Search files...',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontFamily: 'Poppins',
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Color(0xFF6B7280),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    _buildViewToggleButton(
                                      icon: Icons.grid_view,
                                      isSelected: _isGridView,
                                      onTap: () => setState(() => _isGridView = true),
                                    ),
                                    const SizedBox(width: 4),
                                    _buildViewToggleButton(
                                      icon: Icons.list,
                                      isSelected: !_isGridView,
                                      onTap: () => setState(() => _isGridView = false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Content Area
                      Expanded(
                        child: _selectedFolder == null
                            ? _buildEmptyState()
                            : FolderViewScreen(
                                folder: _selectedFolder!,
                                searchQuery: _searchQuery,
                                isGridView: _isGridView,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
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
                icon,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF353E6C) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF353E6C) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF6B7280),
          size: 16,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            child: Icon(
              Icons.upload_file,
              size: 80,
              color: const Color(0xFF353E6C).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No files found. Upload some files to get started!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
