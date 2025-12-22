import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studex_flutter/providers/file_provider.dart';

class OfficeSuiteScreen extends StatefulWidget {
  const OfficeSuiteScreen({super.key});

  @override
  State<OfficeSuiteScreen> createState() => _OfficeSuiteScreenState();
}

class _OfficeSuiteScreenState extends State<OfficeSuiteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office Suite'),
        centerTitle: true,
      ),
      body: Consumer<FileProvider>(
        builder: (context, fileProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Create New Document Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create New Document',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Document Type Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocumentTypeButton(
                                'Word Document',
                                Icons.description,
                                Colors.blue,
                                () => _showCreateDocumentDialog('docx', fileProvider),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDocumentTypeButton(
                                'Excel Spreadsheet',
                                Icons.table_chart,
                                Colors.green,
                                () => _showCreateDocumentDialog('xlsx', fileProvider),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDocumentTypeButton(
                                'PowerPoint Presentation',
                                Icons.slideshow,
                                Colors.orange,
                                () => _showCreateDocumentDialog('pptx', fileProvider),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDocumentTypeButton(
                                'Text Document',
                                Icons.text_fields,
                                Colors.grey,
                                () => _showCreateDocumentDialog('txt', fileProvider),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Recent Documents
                Text(
                  'Recent Documents',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Documents List
                Expanded(
                  child: fileProvider.files.isEmpty
                      ? const Center(
                          child: Text(
                            'No documents created yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: fileProvider.files.length,
                          itemBuilder: (context, index) {
                            final file = fileProvider.files[index];
                            return _buildDocumentCard(file, fileProvider);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDocumentDialog('docx', Provider.of<FileProvider>(context, listen: false));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentTypeButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(dynamic file, FileProvider fileProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFileTypeColor(file.type).withOpacity(0.1),
          child: Icon(
            _getFileTypeIcon(file.type),
            color: _getFileTypeColor(file.type),
          ),
        ),
        title: Text(file.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${file.formattedSize} • ${file.type.toUpperCase()}'),
            Text(
              'Modified: ${_formatDate(file.modifiedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'open',
              child: Text('Open'),
            ),
            const PopupMenuItem(
              value: 'rename',
              child: Text('Rename'),
            ),
            const PopupMenuItem(
              value: 'favorite',
              child: Text('Add to Favorites'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            _handleDocumentAction(value, file, fileProvider);
          },
        ),
        onTap: () {
          _openDocument(file);
        },
      ),
    );
  }

  void _showCreateDocumentDialog(String type, FileProvider fileProvider) {
    final nameController = TextEditingController();
    final contentController = TextEditingController();
    
    // Set default content based on type
    String defaultContent = '';
    switch (type) {
      case 'docx':
        defaultContent = 'New Word Document\n\nStart typing your document here...';
        break;
      case 'xlsx':
        defaultContent = 'A\tB\tC\n1\t2\t3\n4\t5\t6';
        break;
      case 'pptx':
        defaultContent = 'Slide 1\n\nTitle\n\nContent';
        break;
      case 'txt':
        defaultContent = 'New Text Document\n\nStart typing here...';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create ${_getFileTypeName(type)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Document Name',
                suffixText: '.$type',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
              minLines: 3,
              maxLines: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                fileProvider.createDocument(
                  name: nameController.text,
                  type: type,
                  content: contentController.text,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${_getFileTypeName(type)} created')),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _handleDocumentAction(String action, dynamic file, FileProvider fileProvider) {
    switch (action) {
      case 'open':
        _openDocument(file);
        break;
      case 'rename':
        _showRenameDialog(file, fileProvider);
        break;
      case 'favorite':
        fileProvider.toggleFavorite(file.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${file.isFavorite ? 'Removed from' : 'Added to'} favorites')),
        );
        break;
      case 'delete':
        _showDeleteDialog(file, fileProvider);
        break;
    }
  }

  void _openDocument(dynamic file) {
    // Implementation for opening document
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${file.name}')),
    );
  }

  void _showRenameDialog(dynamic file, FileProvider fileProvider) {
    final nameController = TextEditingController(text: file.name.split('.').first);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Document'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'New Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // Implement rename logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document renamed')),
                );
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic file, FileProvider fileProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              fileProvider.deleteFile(file.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getFileTypeIcon(String type) {
    switch (type) {
      case 'word':
        return Icons.description;
      case 'excel':
        return Icons.table_chart;
      case 'powerpoint':
        return Icons.slideshow;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type) {
      case 'word':
        return Colors.blue;
      case 'excel':
        return Colors.green;
      case 'powerpoint':
        return Colors.orange;
      case 'pdf':
        return Colors.red;
      case 'text':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getFileTypeName(String type) {
    switch (type) {
      case 'docx':
        return 'Word Document';
      case 'xlsx':
        return 'Excel Spreadsheet';
      case 'pptx':
        return 'PowerPoint Presentation';
      case 'txt':
        return 'Text Document';
      default:
        return 'Document';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
