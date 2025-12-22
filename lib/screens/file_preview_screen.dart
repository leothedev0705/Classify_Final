import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as path;
// Conditional import for dart:io
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class FilePreviewScreen extends StatefulWidget {
  final File file;

  const FilePreviewScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  String? _fileContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFileContent();
  }

  Future<void> _loadFileContent() async {
    try {
      final fileName = widget.file.path.split('/').last;
      final extension = path.extension(fileName).toLowerCase();

      if (extension == '.txt') {
        _fileContent = await widget.file.readAsString();
      } else if (['.doc', '.docx'].contains(extension)) {
        _fileContent = null; // Will show DOC/DOCX message
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading file: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.path.split('/').last;
    final extension = path.extension(fileName).toLowerCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          fileName,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF353E6C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showFileInfo(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF353E6C)),
              ),
            )
          : _error != null
              ? _buildErrorState()
              : _buildContent(extension),
    );
  }

  Widget _buildContent(String extension) {
    switch (extension) {
      case '.pdf':
        return _buildPDFViewer();
      case '.txt':
        return _buildTextViewer();
      case '.doc':
      case '.docx':
        return _buildDocViewer();
      default:
        return _buildUnsupportedViewer();
    }
  }

  Widget _buildPDFViewer() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PDFView(
          filePath: widget.file.path,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: true,
          onRender: (pages) {
            // PDF rendered
          },
          onError: (error) {
            setState(() {
              _error = 'Error loading PDF: ${error.toString()}';
            });
          },
          onPageError: (page, error) {
            setState(() {
              _error = 'Error loading page: ${error.toString()}';
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextViewer() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: SelectableText(
          _fileContent ?? 'No content available',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF353E6C),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildDocViewer() {
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
              Icons.description,
              size: 64,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'DOC/DOCX Preview',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'DOC/DOCX preview is not implemented.\nPlease download the file to view it with an external application.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showFileInfo,
            icon: const Icon(Icons.info_outline),
            label: const Text('View File Info'),
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

  Widget _buildUnsupportedViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insert_drive_file,
              size: 64,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Unsupported File Type',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This file type cannot be previewed in the app.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Error Loading File',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Unknown error occurred',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              _loadFileContent();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
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

  void _showFileInfo() {
    final fileStats = widget.file.statSync();
    final fileSize = _getFileSize(fileStats.size);
    final modifiedDate = fileStats.modified;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', widget.file.path.split('/').last),
            _buildInfoRow('Size', fileSize),
            _buildInfoRow('Modified', '${modifiedDate.day}/${modifiedDate.month}/${modifiedDate.year}'),
            _buildInfoRow('Path', widget.file.path),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF353E6C),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
