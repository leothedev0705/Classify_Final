import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../widgets/file_card.dart';
import 'file_preview_screen.dart';
// Conditional import for dart:io
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class FolderViewScreen extends StatefulWidget {
  final Directory folder;
  final String searchQuery;
  final bool isGridView;

  const FolderViewScreen({
    Key? key,
    required this.folder,
    required this.searchQuery,
    required this.isGridView,
  }) : super(key: key);

  @override
  State<FolderViewScreen> createState() => _FolderViewScreenState();
}

class _FolderViewScreenState extends State<FolderViewScreen> {
  final FileService _fileService = FileService();
  List<FileSystemEntity> _files = [];
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  void didUpdateWidget(FolderViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folder.path != widget.folder.path ||
        oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.isGridView != widget.isGridView) {
      _loadFiles();
    }
  }

  Future<void> _loadFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final folderName = widget.folder.path.split('/').last;
      final files = await _fileService.getFiles(folderName);
      setState(() {
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error loading files: ${e.toString()}');
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final folderName = widget.folder.path.split('/').last;
      await _fileService.pickAndUploadFile(folderName);
      await _loadFiles();
      _showSnackBar('File uploaded successfully');
    } catch (e) {
      _showSnackBar('Error uploading file: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
      });
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
        final folderName = widget.folder.path.split('/').last;
        final fileName = file.path.split('/').last;
        await _fileService.deleteFile(folderName, fileName);
        await _loadFiles();
        _showSnackBar('File deleted successfully');
      } catch (e) {
        _showSnackBar('Error deleting file: ${e.toString()}');
      }
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
        final folderName = widget.folder.path.split('/').last;
        await _fileService.renameFile(folderName, fileName, result.trim());
        await _loadFiles();
        _showSnackBar('File renamed successfully');
      } catch (e) {
        _showSnackBar('Error renaming file: ${e.toString()}');
      }
    }
  }

  void _previewFile(FileSystemEntity file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilePreviewScreen(file: file as File),
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

  List<FileSystemEntity> get _filteredFiles {
    if (widget.searchQuery.isEmpty) {
      return _files;
    }

    return _files.where((file) {
      final fileName = file.path.split('/').last.toLowerCase();
      return fileName.contains(widget.searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Folder header
          Row(
            children: [
              Icon(
                Icons.folder,
                color: const Color(0xFF353E6C),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.folder.path.split('/').last,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF353E6C),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadFile,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.upload_file, size: 16),
                label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21A366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Files content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF353E6C)),
                    ),
                  )
                : _filteredFiles.isEmpty
                    ? _buildEmptyState()
                    : _buildFilesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF353E6C).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload_file,
              size: 64,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.searchQuery.isEmpty
                ? 'No files in this folder yet. Upload some files to get started!'
                : 'No files found matching "${widget.searchQuery}"',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _uploadFile,
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
        ],
      ),
    );
  }

  Widget _buildFilesList() {
    if (widget.isGridView) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredFiles.length,
        itemBuilder: (context, index) {
          final file = _filteredFiles[index];
          return FileCard(
            file: file,
            isGridView: true,
            onTap: () => _previewFile(file),
            onRename: () => _renameFile(file),
            onDelete: () => _deleteFile(file),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: _filteredFiles.length,
        itemBuilder: (context, index) {
          final file = _filteredFiles[index];
          return FileCard(
            file: file,
            isGridView: false,
            onTap: () => _previewFile(file),
            onRename: () => _renameFile(file),
            onDelete: () => _deleteFile(file),
          );
        },
      );
    }
  }
}
