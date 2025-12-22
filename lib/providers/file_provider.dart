import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/user_file.dart';

class FileProvider extends ChangeNotifier {
  String _selectedFilter = 'all';
  String _selectedCategory = '';
  String _viewMode = 'grid';
  List<UserFile> _files = [];
  List<Map<String, dynamic>> _categories = [
    {'name': 'Homework', 'icon': Icons.school},
    {'name': 'Notes', 'icon': Icons.note},
    {'name': 'Assignments', 'icon': Icons.assignment},
  ];

  String get selectedFilter => _selectedFilter;
  String get selectedCategory => _selectedCategory;
  String get viewMode => _viewMode;
  List<UserFile> get files => _files;
  List<Map<String, dynamic>> get categories => _categories;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void uploadFile() {
    // Legacy stub now creates a placeholder UserFile
    _files.add(UserFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Sample Document.pdf',
      type: 'pdf',
      sizeBytes: 2400000,
      modifiedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void openFile(UserFile file) {
    // Implement file opening
  }

  void downloadFile(UserFile file) {
    // Implement file download
  }

  void deleteFile(String fileId) {
    _files.removeWhere((f) => f.id == fileId);
    notifyListeners();
  }

  void addCategory(String name) {
    _categories.add({
      'name': name,
      'icon': Icons.folder,
    });
    notifyListeners();
  }

  void createWordDocument() {
    _files.add(UserFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Document.docx',
      type: 'word',
      sizeBytes: 0,
      modifiedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void createExcelDocument() {
    _files.add(UserFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Spreadsheet.xlsx',
      type: 'excel',
      sizeBytes: 0,
      modifiedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void createPowerPointDocument() {
    _files.add(UserFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Presentation.pptx',
      type: 'powerpoint',
      sizeBytes: 0,
      modifiedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void openExistingFile() {
    // Implement file picker to open existing files
  }

  // Initialize method for compatibility
  Future<void> initialize() async {
    // Initialize file provider
  }

  // Missing methods for compatibility
  bool get isLoading => false; // Return false for now
  Future<void> pickAndSaveFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: false);
      if (result == null || result.files.isEmpty) return;
      final f = result.files.first;
      final fileName = f.name;
      final ext = (f.extension ?? '').toLowerCase();
      final type = _mapExtensionToType(ext);
      final size = f.size; // bytes
      _files.add(UserFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: fileName,
        type: type,
        sizeBytes: size,
        modifiedAt: DateTime.now(),
        path: f.path,
      ));
      notifyListeners();
    } catch (_) {
      // ignore for now
    }
  }
  void toggleFavorite(String fileId) {
    final idx = _files.indexWhere((f) => f.id == fileId);
    if (idx == -1) return;
    final current = _files[idx];
    _files[idx] = UserFile(
      id: current.id,
      name: current.name,
      type: current.type,
      sizeBytes: current.sizeBytes,
      modifiedAt: current.modifiedAt,
      path: current.path,
      isFavorite: !current.isFavorite,
    );
    notifyListeners();
  }
  void createDocument({required String name, required String type, required String content}) {
    _files.add(UserFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      sizeBytes: 0,
      modifiedAt: DateTime.now(),
      path: null,
    ));
    notifyListeners();
  }

  String _mapExtensionToType(String ext) {
    switch (ext) {
      case 'doc':
      case 'docx':
        return 'word';
      case 'xls':
      case 'xlsx':
        return 'excel';
      case 'ppt':
      case 'pptx':
        return 'powerpoint';
      case 'pdf':
        return 'pdf';
      case 'txt':
        return 'text';
      default:
        return 'unknown';
    }
  }

  // size formatting now provided on model
}
