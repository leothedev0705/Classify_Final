// Stub file for web platform
// This file provides stub classes when dart:io is not available

/// Stub File class matching dart:io File API
class File implements FileSystemEntity {
  @override
  final String path;
  
  File(this.path);
  
  Future<List<int>> readAsBytes() {
    throw UnimplementedError('File operations not available on web platform');
  }
  
  Future<String> readAsString({Encoding encoding = const Utf8Codec()}) {
    throw UnimplementedError('File operations not available on web platform');
  }
  
  bool existsSync() => false;
  Future<bool> exists() async => false;
  Future<File> copy(String newPath) async {
    throw UnimplementedError('File operations not available on web platform');
  }
  Future<void> delete() async {
    throw UnimplementedError('File operations not available on web platform');
  }
  Future<File> rename(String newPath) async {
    throw UnimplementedError('File operations not available on web platform');
  }
  int lengthSync() => 0;
  @override
  DateTime lastModifiedSync() => DateTime.now();
  
  FileStat statSync() => _FileStatStub();
}

/// Stub FileStat class
class _FileStatStub implements FileStat {
  @override
  int get size => 0;
  
  @override
  DateTime get modified => DateTime.now();
  
  @override
  DateTime get changed => DateTime.now();
  
  @override
  DateTime get accessed => DateTime.now();
  
  @override
  int get mode => 0;
  
  @override
  bool get type => false;
  
  @override
  String get modeString => '';
  
  @override
  String toString() => 'FileStat(size: $size)';
}

/// Stub FileStat interface
abstract class FileStat {
  int get size;
  DateTime get modified;
  DateTime get changed;
  DateTime get accessed;
  int get mode;
  bool get type;
  String get modeString;
}

/// Stub Directory class matching dart:io Directory API
class Directory implements FileSystemEntity {
  @override
  final String path;
  
  Directory(this.path);
  
  @override
  DateTime lastModifiedSync() => DateTime.now();
  
  Future<bool> exists() async => false;
  bool existsSync() => false;
  Future<Directory> create({bool recursive = false}) async {
    throw UnimplementedError('Directory operations not available on web platform');
  }
  Stream<FileSystemEntity> list() {
    throw UnimplementedError('Directory operations not available on web platform');
  }
}

/// Stub FileSystemEntity class
abstract class FileSystemEntity {
  String get path;
  DateTime lastModifiedSync() => DateTime.now();
}

/// Stub Encoding class
class Encoding {
  const Encoding();
}

/// Stub Utf8Codec class
class Utf8Codec extends Encoding {
  const Utf8Codec();
}

/// Stub Platform class
class Platform {
  static bool get isWindows => false;
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isAndroid => false;
  static bool get isIOS => false;
}
