class UserFile {
  final String id;
  final String name;
  final String type; // word, excel, powerpoint, pdf, text, unknown
  final int sizeBytes;
  final DateTime modifiedAt;
  final String? path;
  final bool isFavorite;

  UserFile({
    required this.id,
    required this.name,
    required this.type,
    required this.sizeBytes,
    required this.modifiedAt,
    this.path,
    this.isFavorite = false,
  });

  String get formattedSize {
    if (sizeBytes <= 0) return '0 KB';
    const kb = 1024;
    const mb = 1024 * 1024;
    if (sizeBytes >= mb) {
      return '${(sizeBytes / mb).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / kb).toStringAsFixed(1)} KB';
  }
}




