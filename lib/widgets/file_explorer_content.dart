import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../services/file_service.dart';
import '../widgets/folder_card.dart';
import '../widgets/file_card.dart';
import '../screens/folder_view_screen.dart';
import '../screens/file_preview_screen.dart';
import 'TopMostInfoBox/top_most_info_box.dart';
// Conditional import for dart:io
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class FileExplorerContent extends StatefulWidget {
  const FileExplorerContent({Key? key}) : super(key: key);

  @override
  _FileExplorerContentState createState() => _FileExplorerContentState();
}

class _FileExplorerContentState extends State<FileExplorerContent> {
  final FileService _fileService = FileService();
  List<Directory> _folders = [];
  Directory? _selectedFolder;
  bool _isGridView = true;
  String _searchQuery = '';
  bool _isLoading = false;
  String _selectedView = 'All Files'; // Track current view
  List<FileSystemEntity> _allFiles = []; // Store all files for different views

  @override
  void initState() {
    super.initState();
    _loadFolders();
    _loadAllFiles();
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

  Future<void> _loadAllFiles() async {
    try {
      final allFiles = <FileSystemEntity>[];
      final folders = await _fileService.getFolders();
      
      for (final folder in folders) {
        final folderName = folder.path.split('/').last;
        final files = await _fileService.getFiles(folderName);
        allFiles.addAll(files);
      }
      
      setState(() {
        _allFiles = allFiles;
      });
    } catch (e) {
      _showSnackBar('Error loading files: ${e.toString()}');
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
        _showSnackBar('Folder "${result.trim()}" created successfully');
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.contains('UnsupportedError') || errorMessage.contains('web platform')) {
          _showSnackBar('File operations are not available on web platform. Please use the desktop app.');
        } else {
          _showSnackBar('Error creating folder: $errorMessage');
        }
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

  // Handle different view selections
  void _selectView(String view) {
    setState(() {
      _selectedView = view;
      _selectedFolder = null; // Clear folder selection when changing views
    });
  }

  // Upload file to a specific folder
  Future<void> _uploadFileToFolder(String folderName) async {
    try {
      await _fileService.pickAndUploadFile(folderName);
      await _loadAllFiles(); // Refresh all files
      _showSnackBar('File uploaded successfully to $folderName');
    } catch (e) {
      _showSnackBar('Error uploading file: ${e.toString()}');
    }
  }

  // Upload file to any folder (show folder selection)
  Future<void> _uploadFileAnywhere() async {
    if (_folders.isEmpty) {
      _showSnackBar('No folders available. Create a folder first.');
      return;
    }

    // Show folder selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Folder'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _folders.length,
            itemBuilder: (context, index) {
              final folder = _folders[index];
              final folderName = folder.path.split('/').last;
              return ListTile(
                leading: const Icon(Icons.folder),
                title: Text(folderName),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadFileToFolder(folderName);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Get files based on selected view
  List<FileSystemEntity> _getFilesForView() {
    switch (_selectedView) {
      case 'All Files':
        return _allFiles;
      case 'Recent Files':
        final recentFiles = List<FileSystemEntity>.from(_allFiles);
        recentFiles.sort((a, b) {
          if (a is File && b is File) {
            return b.lastModifiedSync().compareTo(a.lastModifiedSync());
          }
          return 0;
        });
        return recentFiles.take(20).toList();
      case 'Documents':
        return _allFiles.where((file) {
          final fileName = file.path.toLowerCase();
          return fileName.endsWith('.doc') || fileName.endsWith('.docx') || fileName.endsWith('.txt');
        }).toList();
      case 'PDFs':
        return _allFiles.where((file) {
          return file.path.toLowerCase().endsWith('.pdf');
        }).toList();
      case 'Other Files':
        return _allFiles.where((file) {
          final fileName = file.path.toLowerCase();
          return !fileName.endsWith('.pdf') && 
                 !fileName.endsWith('.doc') && 
                 !fileName.endsWith('.docx') && 
                 !fileName.endsWith('.txt');
        }).toList();
      default:
        return _allFiles;
    }
  }

  // Get filtered files based on search query
  List<FileSystemEntity> _getFilteredFiles() {
    final files = _getFilesForView();
    if (_searchQuery.isEmpty) {
      return files;
    }
    
    return files.where((file) {
      final fileName = file.path.split('/').last.toLowerCase();
      return fileName.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // TopMost Info Box
          const TopMostInfoBox(
            title: 'Manage your files',
            subtitle: 'Upload, organize and find anything fast.',
            imageAsset: 'assets/images/home-girl.png',
          ),
          const SizedBox(height: 24),
          // File Manager Container
          Container(
            height: MediaQuery.of(context).size.height - 200,
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
                              _selectedView == 'All Files' && _selectedFolder == null,
                              () => _selectView('All Files'),
                            ),
                            _buildQuickAccessItem(
                              'Recent Files',
                              Icons.access_time,
                              _selectedView == 'Recent Files',
                              () => _selectView('Recent Files'),
                            ),
                            _buildQuickAccessItem(
                              'Documents',
                              Icons.description,
                              _selectedView == 'Documents',
                              () => _selectView('Documents'),
                            ),
                            _buildQuickAccessItem(
                              'PDFs',
                              Icons.picture_as_pdf,
                              _selectedView == 'PDFs',
                              () => _selectView('PDFs'),
                            ),
                            _buildQuickAccessItem(
                              'Other Files',
                              Icons.insert_drive_file,
                              _selectedView == 'Other Files',
                              () => _selectView('Other Files'),
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
                                  onTap: () {
                                    setState(() {
                                      _selectedFolder = folder;
                                      _selectedView = folder.path.split('/').last;
                                    });
                                  },
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
                          child: _buildMainContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildMainContent() {
    if (_selectedFolder != null) {
      // Show folder view
      return FolderViewScreen(
        folder: _selectedFolder!,
        searchQuery: _searchQuery,
        isGridView: _isGridView,
      );
    } else {
      // Show files based on selected view
      final files = _getFilteredFiles();
      
      if (files.isEmpty) {
        return _buildEmptyState();
      }
      
      if (_isGridView) {
        return _buildGridView(files);
      } else {
        return _buildListView(files);
      }
    }
  }

  Widget _buildGridView(List<FileSystemEntity> files) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return FileCard(
          file: file,
          isGridView: true,
          onTap: () => _openFile(file),
          onRename: () => _renameFile(file),
          onDelete: () => _deleteFile(file),
        );
      },
    );
  }

  Widget _buildListView(List<FileSystemEntity> files) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return FileCard(
          file: file,
          isGridView: false,
          onTap: () => _openFile(file),
          onRename: () => _renameFile(file),
          onDelete: () => _deleteFile(file),
        );
      },
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
          Text(
            _selectedView == 'All Files' 
                ? 'No files found. Upload some files to get started!'
                : 'No ${_selectedView.toLowerCase()} found.',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _uploadFileAnywhere,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Files'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF353E6C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // File operations
  void _openFile(FileSystemEntity file) async {
    if (file is File) {
      final fileInstance = file as File;
      // Try to open with system default app first
      final result = await OpenFile.open(fileInstance.path);
      if (result.type != ResultType.done) {
        // If system app can't open it, use preview screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FilePreviewScreen(file: fileInstance),
          ),
        );
      }
    } else {
      // For directories, could navigate to folder view
      _showSnackBar('Cannot open directory');
    }
  }

  Future<void> _renameFile(FileSystemEntity file) async {
    final fileName = file.path.split('/').last;
    final TextEditingController controller = TextEditingController(text: fileName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter new file name',
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
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty && result != fileName) {
      try {
        // Find which folder this file belongs to
        final filePath = file.path;
        final pathParts = filePath.split('/');
        final folderName = pathParts[pathParts.length - 2]; // Parent folder
        
        await _fileService.renameFile(folderName, fileName, result.trim());
        await _loadAllFiles();
        _showSnackBar('File renamed successfully');
      } catch (e) {
        _showSnackBar('Error renaming file: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${file.path.split('/').last}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Find which folder this file belongs to
        final filePath = file.path;
        final pathParts = filePath.split('/');
        final folderName = pathParts[pathParts.length - 2]; // Parent folder
        final fileName = file.path.split('/').last;
        
        await _fileService.deleteFile(folderName, fileName);
        await _loadAllFiles();
        _showSnackBar('File deleted successfully');
      } catch (e) {
        _showSnackBar('Error deleting file: ${e.toString()}');
      }
    }
  }
}
