import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:typed_data';
import 'TopMostInfoBox/top_most_info_box.dart';
import 'package:path/path.dart' as path;

// Import dart:io for file operations (only used on non-web platforms)
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class OfficeSuiteContent extends StatefulWidget {
  const OfficeSuiteContent({Key? key}) : super(key: key);

  @override
  _OfficeSuiteContentState createState() => _OfficeSuiteContentState();
}

class _OfficeSuiteContentState extends State<OfficeSuiteContent> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  int selectedTab = 0; // 0 = Tools, 1 = Templates, 2 = Recent

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TopMost Info Box
          const TopMostInfoBox(
        title: 'Create and edit documents',
        subtitle: 'Word, Excel, PowerPoint — all in one place.',
            imageAsset: 'assets/images/Tools.png',

          ),
          const SizedBox(height: 24),
          // Content area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Explore Tools',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF353E6C),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Search bar and tabs inside white box
                Row(
                  children: [
                    // Search field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFC5C7D0), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 14),
                              child: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Tab buttons
                    _buildTabButton('Tools', 0),
                    const SizedBox(width: 8),
                    _buildTabButton('Templates', 1),
                    const SizedBox(width: 8),
                    _buildTabButton('Recent', 2),
                  ],
                ),
                const SizedBox(height: 24),
                // Content area
                _buildContentArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    switch (selectedTab) {
      case 0: // Tools
        return _buildToolsGrid();
      case 1: // Templates
        return _buildTemplatesContent();
      case 2: // Recent
        return _buildRecentContent();
      default:
        return _buildToolsGrid();
    }
  }

  Widget _buildToolsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
         Row(
           children: [
             _buildOfficeCard(
               title: 'POWERPOINT',
               darkColor: const Color(0xFFCF4D2A),
               assetPath: 'assets/icons/powerpoint_logo.png',
               fallbackIcon: Icons.slideshow,
               onTap: () => _openEmbeddedTool('PowerPoint'),
             ),
             const SizedBox(width: 16),
             _buildOfficeCard(
               title: 'EXCEL',
               darkColor: const Color(0xFF187A3B),
               assetPath: 'assets/icons/Excel_Logo.png',
               fallbackIcon: Icons.table_chart,
               onTap: () => _openEmbeddedTool('Excel'),
             ),
             const SizedBox(width: 16),
             _buildOfficeCard(
               title: 'WORD',
               darkColor: const Color(0xFF1B63C7),
               assetPath: 'assets/icons/Word_logo.png',
               fallbackIcon: Icons.description,
               onTap: () => _openEmbeddedTool('Word'),
             ),
             const SizedBox(width: 16),
             _buildOfficeCard(
               title: 'OPEN FILE',
               darkColor: const Color(0xFFF2A500),
               assetPath: 'assets/icons/File_logo.png',
               fallbackIcon: Icons.folder_open,
               onTap: () => _openEmbeddedTool('File'),
             ),
           ],
         ),
      ],
    );
  }

  Widget _buildTemplatesContent() {
    return Center(
      child: Text(
        'Templates content will appear here',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: const Color(0xFF353E6C).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildRecentContent() {
    return Center(
      child: Text(
        'Recent files content will appear here',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: const Color(0xFF353E6C).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildOfficeCard({
    required String title,
    required Color darkColor,
    String? assetPath,
    IconData? fallbackIcon,
    VoidCallback? onTap,
  }) {
    // Use specific backgrounds for each card
    Color lightColor;
    Color borderColor;
    Color circleColor;
    
    switch (title) {
      case 'POWERPOINT':
        lightColor = const Color(0xFFFFE0D7);
        borderColor = darkColor;
        circleColor = darkColor;
        break;
      case 'WORD':
        lightColor = const Color(0xFFE7F5FF);
        borderColor = const Color(0xFF2B7CD3);
        circleColor = const Color(0xFF2B7CD3);
        break;
      case 'EXCEL':
        lightColor = const Color(0xFFD0FFE9);
        borderColor = const Color(0xFF21A366);
        circleColor = const Color(0xFF21A366);
        break;
      case 'OPEN FILE':
        lightColor = const Color(0xFFFFF6D5);
        borderColor = const Color(0xFFFFB02E);
        circleColor = const Color(0xFFFFB02E);
        break;
      default:
        lightColor = Color.fromRGBO(
          (darkColor.r * 255 * 2).round() ~/ 3,
          (darkColor.g * 255 * 2).round() ~/ 3,
          (darkColor.b * 255 * 2).round() ~/ 3,
          1.0,
        );
        borderColor = darkColor;
        circleColor = darkColor;
    }
    
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Stack(
            children: [
              // Large decorative circle in top-right corner
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: circleColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Smaller decorative circle in bottom-left corner
              Positioned(
                bottom: -15,
                left: -15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: circleColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main content - centered
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo without background
                    assetPath != null
                        ? Image.asset(
                            assetPath,
                            width: 70,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              fallbackIcon ?? Icons.apps,
                              size: 70,
                              color: darkColor,
                            ),
                          )
                        : Icon(
                            fallbackIcon ?? Icons.apps,
                            size: 70,
                            color: darkColor,
                          ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: darkColor,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEmbeddedTool(String toolName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _EmbeddedToolScreen(toolName: toolName),
      ),
    );
  }

  Widget _buildTabButton(String label, int tabIndex) {
    final isSelected = selectedTab == tabIndex;
    return InkWell(
      onTap: () => setState(() => selectedTab = tabIndex),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF353E6C) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF353E6C),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF353E6C),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmbeddedToolScreen extends StatefulWidget {
  final String toolName;

  const _EmbeddedToolScreen({required this.toolName});

  @override
  _EmbeddedToolScreenState createState() => _EmbeddedToolScreenState();
}

class _EmbeddedToolScreenState extends State<_EmbeddedToolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.toolName} Editor'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF353E6C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildToolContent(),
    );
  }

  Widget _buildToolContent() {
    switch (widget.toolName) {
      case 'Word':
        return _buildWordEditor();
      case 'Excel':
        return _buildExcelEditor();
      case 'PowerPoint':
        return _buildPowerPointEditor();
      case 'File':
        return _buildFileManager();
      default:
        return _buildGenericEditor();
    }
  }

  Widget _buildWordEditor() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _createNewWordDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _openWordDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                const Spacer(),
                Text(
                  'Microsoft Word Online',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // Word Editor WebView
          Expanded(
            child: _buildWordWebView(),
          ),
        ],
      ),
    );
  }

  Widget _buildExcelEditor() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _createNewExcelDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _openExcelDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                const Spacer(),
                Text(
                  'Microsoft Excel Online',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // Excel Editor WebView
          Expanded(
            child: _buildExcelWebView(),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerPointEditor() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _createNewPowerPointDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _openPowerPointDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {},
                  color: const Color(0xFF353E6C),
                ),
                const Spacer(),
                Text(
                  'Microsoft PowerPoint Online',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // PowerPoint Editor WebView
          Expanded(
            child: _buildPowerPointWebView(),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerPointWebView() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildWebViewWithFallback('https://office.com/launch/powerpoint'),
      ),
    );
  }

  void _createNewPowerPointDocument() {
    // Create a new PowerPoint document using Office Online
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _WordDocumentScreen(
          documentUrl: 'https://office.com/launch/powerpoint?wdOrigin=1',
          isNewDocument: true,
        ),
      ),
    );
  }

  Widget _buildFileManager() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _openLocalFile,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _openOfficeDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: _openPDFDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.table_chart),
                  onPressed: _openExcelDocument,
                  color: const Color(0xFF353E6C),
                ),
                IconButton(
                  icon: const Icon(Icons.slideshow),
                  onPressed: _openPowerPointDocument,
                  color: const Color(0xFF353E6C),
                ),
                const Spacer(),
                Text(
                  'File Explorer',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // File Manager Content
          Expanded(
            child: _buildFileManagerContent(),
          ),
        ],
      ),
    );
  }


  Widget _buildGenericEditor() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 16),
            Text(
              'Tool Editor',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This tool editor is coming soon!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to handle file picking for both web and other platforms
  Future<String?> _getFilePathFromPicker(FilePickerResult? result) async {
    if (result == null || result.files.isEmpty) return null;
    
    final file = result.files.single;
    
    if (kIsWeb) {
      // On web, path is null, use bytes instead
      // For web, we'll use a data URL or handle it differently
      // Since we can't save to file system on web, we'll return a placeholder
      // The document viewer will need to handle bytes directly
      if (file.bytes != null) {
        // On web, we can't create a file path, so we'll need to handle this differently
        // For now, return null and handle bytes in the viewer
        return null; // Will need to pass bytes directly
      }
      return null;
    } else {
      // On other platforms, use path
      return file.path;
    }
  }
  
  // Helper method to get file bytes (for web platform)
  Uint8List? _getFileBytes(FilePickerResult? result) {
    if (result == null || result.files.isEmpty) return null;
    return result.files.single.bytes;
  }

  // File picker methods
  Future<void> _openPDFDocument() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        _openDocumentViewer(filePath, 'PDF');
      }
    } catch (e) {
      _showErrorDialog('Error opening PDF file: $e');
    }
  }

  Future<void> _openWordDocument() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'doc'],
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        _openDocumentViewer(filePath, 'Word');
      }
    } catch (e) {
      _showErrorDialog('Error opening Word document: $e');
    }
  }

  Future<void> _openExcelDocument() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        _openDocumentViewer(filePath, 'Excel');
      }
    } catch (e) {
      _showErrorDialog('Error opening Excel file: $e');
    }
  }

  Future<void> _openPowerPointDocument() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pptx', 'ppt'],
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        _openDocumentViewer(filePath, 'PowerPoint');
      }
    } catch (e) {
      _showErrorDialog('Error opening PowerPoint file: $e');
    }
  }

  Future<void> _openOfficeDocument() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'xlsx', 'xls', 'pptx', 'ppt'],
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        String extension = path.extension(filePath).toLowerCase().replaceFirst('.', '');
        
        String documentType = 'Office';
        if (extension == 'pdf') documentType = 'PDF';
        else if (['docx', 'doc'].contains(extension)) documentType = 'Word';
        else if (['xlsx', 'xls'].contains(extension)) documentType = 'Excel';
        else if (['pptx', 'ppt'].contains(extension)) documentType = 'PowerPoint';
        
        _openDocumentViewer(filePath, documentType);
      }
    } catch (e) {
      _showErrorDialog('Error opening office document: $e');
    }
  }

  Future<void> _openLocalFile() async {
    if (kIsWeb) {
      _showErrorDialog('File upload is not supported on web. Please use Office Online to upload files.');
      return;
    }
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      final filePath = await _getFilePathFromPicker(result);
      if (filePath != null) {
        String extension = path.extension(filePath).toLowerCase().replaceFirst('.', '');
        
        // Check if it's a supported office document type
        if (['pdf', 'docx', 'doc', 'xlsx', 'xls', 'pptx', 'ppt'].contains(extension)) {
          String documentType = 'Office';
          if (extension == 'pdf') documentType = 'PDF';
          else if (['docx', 'doc'].contains(extension)) documentType = 'Word';
          else if (['xlsx', 'xls'].contains(extension)) documentType = 'Excel';
          else if (['pptx', 'ppt'].contains(extension)) documentType = 'PowerPoint';
          
          _openDocumentViewer(filePath, documentType);
        } else {
          _showErrorDialog('Unsupported file type. Please select PDF, Word, Excel, or PowerPoint files.');
        }
      }
    } catch (e) {
      _showErrorDialog('Error opening file: $e');
    }
  }

  void _openDocumentViewer(String filePath, String documentType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DocumentViewerScreen(
          filePath: filePath,
          documentType: documentType,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Word Editor Methods
  Widget _buildWordWebView() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildWebViewWithFallback('https://office.com/launch/word'),
      ),
    );
  }

  void _createNewWordDocument() {
    // Create a new Word document using Office Online
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _WordDocumentScreen(
          documentUrl: 'https://office.com/launch/word?wdOrigin=1',
          isNewDocument: true,
        ),
      ),
    );
  }

  Widget _buildExcelWebView() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildWebViewWithFallback('https://office.com/launch/excel'),
      ),
    );
  }

  Widget _buildWebViewWithFallback(String url) {
    try {
      final controller = WebViewController();
      
      // setBackgroundColor and setJavaScriptMode are not supported on web platform
      if (!kIsWeb) {
        controller.setBackgroundColor(Colors.white);
        controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      }
      
      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Page started loading
          },
          onPageFinished: (String url) {
            // Page finished loading
          },
          onWebResourceError: (WebResourceError error) {
            _showErrorDialog('Failed to load Office Online: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Keep all navigation within the WebView (iframe-like behavior)
            // Only allow navigation to Office.com domains
            final uri = Uri.parse(request.url);
            if (uri.host.contains('office.com') || 
                uri.host.contains('microsoft.com') ||
                uri.host.contains('office365.com') ||
                uri.host.contains('live.com') ||
                uri.host.contains('outlook.com') ||
                uri.host.contains('sharepoint.com') ||
                uri.host.contains('onedrive.com')) {
              return NavigationDecision.navigate;
            }
            // Block external navigation - keep it in the WebView
            return NavigationDecision.prevent;
          },
        ),
      );
      
      controller.loadRequest(Uri.parse(url));
      
      return WebViewWidget(controller: controller);
    } catch (e) {
      // Fallback UI if WebView fails to initialize
      return _buildWebViewFallback(url);
    }
  }

  Widget _buildWebViewFallback(String url) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.language,
              size: 64,
              color: Color(0xFF353E6C),
            ),
            const SizedBox(height: 16),
            const Text(
              'Office Online',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Microsoft Office Online is available in your browser',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Open in external browser
                // You can use url_launcher package here
                _showErrorDialog('Please open Microsoft Office Online in your browser at: $url');
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in Browser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF353E6C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewExcelDocument() {
    // Create a new Excel document using Office Online
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _WordDocumentScreen(
          documentUrl: 'https://office.com/launch/excel?wdOrigin=1',
          isNewDocument: true,
        ),
      ),
    );
  }

  Widget _buildFileManagerContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF353E6C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.attach_file,
                  color: Color(0xFF353E6C),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick File Access',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF353E6C),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quickly attach and open files like WhatsApp',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Quick file picker buttons
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildQuickFileButton(
                'Open Any File',
                Icons.folder_open,
                const Color(0xFF353E6C),
                _openLocalFile,
              ),
              _buildQuickFileButton(
                'PDF Documents',
                Icons.picture_as_pdf,
                const Color(0xFFDC2626),
                _openPDFDocument,
              ),
              _buildQuickFileButton(
                'Word Documents',
                Icons.description,
                const Color(0xFF2563EB),
                _openWordDocument,
              ),
              _buildQuickFileButton(
                'Excel Spreadsheets',
                Icons.table_chart,
                const Color(0xFF16A34A),
                _openExcelDocument,
              ),
              _buildQuickFileButton(
                'PowerPoint Slides',
                Icons.slideshow,
                const Color(0xFFEA580C),
                _openPowerPointDocument,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Info box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '• Click any button above to quickly open files from your device\n'
                  '• Files open directly in the app or external apps\n'
                  '• Perfect for quick document access while working\n'
                  '• For full file organization, use the File Explorer section',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFileButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: 140,
      height: 100,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentViewerScreen extends StatelessWidget {
  final String filePath;
  final String documentType;

  const _DocumentViewerScreen({
    required this.filePath,
    required this.documentType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${documentType} Viewer'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF353E6C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildDocumentViewer(),
    );
  }

  Widget _buildDocumentViewer() {
    switch (documentType) {
      case 'PDF':
        return _buildPDFViewer();
      case 'Word':
      case 'Excel':
      case 'PowerPoint':
        return _buildOfficeViewer();
      default:
        return _buildGenericViewer();
    }
  }

  Widget _buildPDFViewer() {
    if (kIsWeb) {
      return const Center(
        child: Text(
          'PDF viewing is not available on web platform.\nPlease use Office Online to view PDFs.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }
    
    return PDFView(
      filePath: filePath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: true,
      onRender: (pages) {
        // PDF rendered
      },
      onError: (error) {
        // Handle error
      },
      onPageError: (page, error) {
        // Handle page error
      },
    );
  }

  Widget _buildOfficeViewer() {
    if (kIsWeb) {
      return const Center(
        child: Text(
          'Office document viewing is not available on web platform.\nPlease use Office Online to view documents.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }
    
    // Only use File on non-web platforms
    // Note: File is from dart:io (or stub on web, but this code path is never reached on web)
    return FutureBuilder<List<int>>(
      future: File(filePath).readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF353E6C)),
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading document',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF353E6C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        if (snapshot.hasData) {
          return _buildWebViewForOffice(documentType);
        }
        
        return const Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenericViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file,
            size: 64,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 16),
          Text(
            'Document Viewer',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'File: ${filePath.split('/').last}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type: $documentType',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewForOffice(String documentType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description,
            size: 64,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 16),
          Text(
            '$documentType Document',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF353E6C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'File: ${filePath.split('/').last}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Open with external app
              // You can use open_file package here
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open with External App'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF353E6C),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _WordDocumentScreen extends StatefulWidget {
  final String documentUrl;
  final bool isNewDocument;

  const _WordDocumentScreen({
    required this.documentUrl,
    required this.isNewDocument,
  });

  @override
  State<_WordDocumentScreen> createState() => _WordDocumentScreenState();
}

class _WordDocumentScreenState extends State<_WordDocumentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    
    // setBackgroundColor and setJavaScriptMode are not supported on web platform
    if (!kIsWeb) {
      _controller.setBackgroundColor(Colors.white);
      _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }
    
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Failed to load document: ${error.description}');
        },
        onNavigationRequest: (NavigationRequest request) {
          // Keep all navigation within the WebView (iframe-like behavior)
          // Only allow navigation to Office.com domains
          final uri = Uri.parse(request.url);
          if (uri.host.contains('office.com') || 
              uri.host.contains('microsoft.com') ||
              uri.host.contains('office365.com') ||
              uri.host.contains('live.com') ||
              uri.host.contains('outlook.com') ||
              uri.host.contains('sharepoint.com') ||
              uri.host.contains('onedrive.com')) {
            return NavigationDecision.navigate;
          }
          // Block external navigation - keep it in the WebView
          return NavigationDecision.prevent;
        },
      ),
    );
    
    _controller.loadRequest(Uri.parse(widget.documentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewDocument ? 'New Document' : 'Word Document'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF353E6C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () {
              // Open in external browser
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildSafeWebView(),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF353E6C)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading Microsoft Word...',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFF353E6C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSafeWebView() {
    try {
      return WebViewWidget(controller: _controller);
    } catch (e) {
      return _buildWebViewFallback(widget.documentUrl);
    }
  }

  Widget _buildWebViewFallback(String url) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.language,
              size: 64,
              color: Color(0xFF353E6C),
            ),
            const SizedBox(height: 16),
            const Text(
              'Office Online',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF353E6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Microsoft Office Online is available in your browser',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showErrorDialog('Please open Microsoft Office Online in your browser at: $url');
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in Browser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF353E6C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
