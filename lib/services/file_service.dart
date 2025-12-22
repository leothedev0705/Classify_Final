import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

// Conditional import for dart:io
import 'dart:io' if (dart.library.html) 'package:studex_flutter/utils/file_stub.dart';

class FileService {
  static const String baseFolderName = 'StudyDrive';
  static const List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'txt'];

  /// Get the base path for StudyDrive
  Future<String> getBasePath() async {
    if (kIsWeb) {
      // On web, file system operations are not available
      throw UnsupportedError('File system operations are not available on web platform');
    }
    
    final appDocDir = await getApplicationDocumentsDirectory();
    final basePath = path.join(appDocDir.path, baseFolderName);
    
    // Create base directory if it doesn't exist
    final baseDir = Directory(basePath);
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }
    
    return basePath;
  }

  /// Create a new folder
  Future<void> createFolder(String name) async {
    if (kIsWeb) {
      throw UnsupportedError('File system operations are not available on web platform');
    }
    
    if (name.trim().isEmpty) {
      throw Exception('Folder name cannot be empty');
    }

    final basePath = await getBasePath();
    final folderPath = path.join(basePath, name.trim());
    final folder = Directory(folderPath);

    if (await folder.exists()) {
      throw Exception('Folder with this name already exists');
    }

    await folder.create(recursive: true);
  }

  /// Get all folders in StudyDrive
  Future<List<Directory>> getFolders() async {
    if (kIsWeb) {
      // On web, return empty list with proper type casting
      return <Directory>[];
    }
    
    final basePath = await getBasePath();
    final baseDir = Directory(basePath);
    
    if (!await baseDir.exists()) {
      return <Directory>[];
    }

    final entities = await baseDir.list().toList();
    final folders = <Directory>[];

    for (final entity in entities) {
      if (entity is Directory) {
        folders.add(entity as Directory);
      }
    }

    return folders;
  }

  /// Get all files in a specific folder
  Future<List<FileSystemEntity>> getFiles(String folderName) async {
    if (kIsWeb) {
      // On web, return empty list with proper type casting
      return <FileSystemEntity>[];
    }
    
    final basePath = await getBasePath();
    final folderPath = path.join(basePath, folderName);
    final folder = Directory(folderPath);

    if (!await folder.exists()) {
      return [];
    }

    final entities = await folder.list().toList();
    final files = <FileSystemEntity>[];

    for (final entity in entities) {
      if (entity is File && isAllowedExtension(entity.path)) {
        files.add(entity);
      }
    }

    return files;
  }

  /// Pick and upload a file to a specific folder
  Future<File?> pickAndUploadFile(String folderName) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);
        final fileName = result.files.single.name;

        // Validate file extension
        if (!isAllowedExtension(fileName)) {
          throw Exception('File type not allowed. Only PDF, DOC, DOCX, and TXT files are supported.');
        }

        final basePath = await getBasePath();
        final folderPath = path.join(basePath, folderName);
        final folder = Directory(folderPath);

        if (!await folder.exists()) {
          throw Exception('Folder does not exist');
        }

        final destinationPath = path.join(folderPath, fileName);
        final destinationFile = File(destinationPath);

        // Handle file name conflicts
        String finalFileName = fileName;
        String finalDestinationPath = destinationPath;
        int counter = 1;

        while (await destinationFile.exists()) {
          final nameWithoutExt = path.basenameWithoutExtension(fileName);
          final extension = path.extension(fileName);
          finalFileName = '${nameWithoutExt}($counter)$extension';
          finalDestinationPath = path.join(folderPath, finalFileName);
          counter++;
        }

        // Copy file to destination
        final finalFile = File(finalDestinationPath);
        await pickedFile.copy(finalDestinationPath);

        return finalFile;
      }
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }

    return null;
  }

  /// Delete a file from a specific folder
  Future<void> deleteFile(String folderName, String fileName) async {
    final basePath = await getBasePath();
    final filePath = path.join(basePath, folderName, fileName);
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('File does not exist');
    }

    await file.delete();
  }

  /// Rename a file in a specific folder
  Future<void> renameFile(String folderName, String oldName, String newName) async {
    if (newName.trim().isEmpty) {
      throw Exception('File name cannot be empty');
    }

    // Validate new file extension
    if (!isAllowedExtension(newName)) {
      throw Exception('File type not allowed. Only PDF, DOC, DOCX, and TXT files are supported.');
    }

    final basePath = await getBasePath();
    final oldPath = path.join(basePath, folderName, oldName);
    final newPath = path.join(basePath, folderName, newName.trim());

    final oldFile = File(oldPath);
    final newFile = File(newPath);

    if (!await oldFile.exists()) {
      throw Exception('Original file does not exist');
    }

    if (await newFile.exists()) {
      throw Exception('A file with this name already exists');
    }

    await oldFile.rename(newPath);
  }

  /// Check if file extension is allowed
  bool isAllowedExtension(String filename) {
    final extension = path.extension(filename).toLowerCase().substring(1);
    return allowedExtensions.contains(extension);
  }

  /// Get file size in human readable format
  String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get file modification date
  DateTime getFileDate(File file) {
    return file.lastModifiedSync();
  }
}
