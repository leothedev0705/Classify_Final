import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:studex_flutter/providers/file_provider.dart';
import 'package:studex_flutter/models/user_file.dart';
import 'package:studex_flutter/screens/file_preview_screen.dart';
import 'dart:io';

class FileExplorerScreen extends StatefulWidget {
  const FileExplorerScreen({super.key});

  @override
  State<FileExplorerScreen> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends State<FileExplorerScreen> {
  String _selectedFilter = 'all';
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Explorer'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Text('Sort'),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Text('Filter'),
              ),
              const PopupMenuItem(
                value: 'view',
                child: Text('View Options'),
              ),
            ],
            onSelected: (value) {
              _handleMenuAction(value);
            },
          ),
        ],
      ),
      body: Consumer<FileProvider>(
        builder: (context, fileProvider, child) {
          if (fileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Filter and Sort Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  children: [
                    // Filter Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilter,
                        decoration: const InputDecoration(
                          labelText: 'Filter',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Files')),
                          DropdownMenuItem(value: 'word', child: Text('Word Documents')),
                          DropdownMenuItem(value: 'excel', child: Text('Excel Spreadsheets')),
                          DropdownMenuItem(value: 'powerpoint', child: Text('PowerPoint Presentations')),
                          DropdownMenuItem(value: 'pdf', child: Text('PDF Documents')),
                          DropdownMenuItem(value: 'text', child: Text('Text Files')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort Button
                    IconButton(
                      onPressed: () {
                        _showSortDialog();
                      },
                      icon: const Icon(Icons.sort),
                    ),
                  ],
                ),
              ),
              
              // Files List
              Expanded(
                child: _buildFilesList(fileProvider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<FileProvider>(context, listen: false).pickAndSaveFile();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilesList(FileProvider fileProvider) {
    List<UserFile> files = List<UserFile>.from(fileProvider.files);
    
    // Apply filter
    if (_selectedFilter != 'all') {
      files = files.where((file) => file.type == _selectedFilter).toList();
    }
    
    // Apply sort
    files.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'size':
          comparison = a.sizeBytes.compareTo(b.sizeBytes);
          break;
        case 'date':
          comparison = a.modifiedAt.compareTo(b.modifiedAt);
          break;
        case 'type':
          comparison = a.type.compareTo(b.type);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'all' 
                  ? 'No files found'
                  : 'No ${_selectedFilter} files found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add files',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _buildFileCard(file, fileProvider);
      },
    );
  }

  Widget _buildFileCard(UserFile file, FileProvider fileProvider) {
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
        title: Text(
          file.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (file.isFavorite)
              const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
            PopupMenuButton(
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
                  child: Text('Toggle Favorite'),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Text('Share'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) {
                _handleFileAction(value, file, fileProvider);
              },
            ),
          ],
        ),
        onTap: () {
          _openFile(file);
        },
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'sort':
        _showSortDialog();
        break;
      case 'filter':
        _showFilterDialog();
        break;
      case 'view':
        _showViewOptionsDialog();
        break;
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Files'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Name'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Size'),
              value: 'size',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Date Modified'),
              value: 'date',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Type'),
              value: 'type',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Ascending'),
              value: _sortAscending,
              onChanged: (value) {
                setState(() {
                  _sortAscending = value;
                });
              },
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
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Files'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Files'),
              value: 'all',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Word Documents'),
              value: 'word',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Excel Spreadsheets'),
              value: 'excel',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('PowerPoint Presentations'),
              value: 'powerpoint',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('PDF Documents'),
              value: 'pdf',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Text Files'),
              value: 'text',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
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
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showViewOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('View Options'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('List View'),
              subtitle: Text('Current view'),
            ),
            ListTile(
              leading: Icon(Icons.view_module),
              title: Text('Grid View'),
              subtitle: Text('Coming soon'),
            ),
            ListTile(
              leading: Icon(Icons.view_agenda),
              title: Text('Detail View'),
              subtitle: Text('Coming soon'),
            ),
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

  void _handleFileAction(String action, UserFile file, FileProvider fileProvider) {
    switch (action) {
      case 'open':
        _openFile(file);
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
      case 'share':
        _showShareDialog(file);
        break;
      case 'delete':
        _showDeleteDialog(file, fileProvider);
        break;
    }
  }

  void _openFile(UserFile file) async {
    if (file.path != null && await File(file.path!).exists()) {
      // Try to open with system default app
      final result = await OpenFile.open(file.path!);
      if (result.type != ResultType.done) {
        // If system app can't open it, try preview screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FilePreviewScreen(file: File(file.path!)),
          ),
        );
      }
    } else {
      // Show preview screen or error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File not found: ${file.name}')),
      );
    }
  }

  void _showRenameDialog(UserFile file, FileProvider fileProvider) {
    final nameController = TextEditingController(text: file.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'New Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && nameController.text != file.name) {
                try {
                  if (file.path != null) {
                    final oldFile = File(file.path!);
                    if (await oldFile.exists()) {
                      final directory = oldFile.parent;
                      final newPath = '${directory.path}/${nameController.text}';
                      await oldFile.rename(newPath);
                      
                      // Update file provider
                      fileProvider.deleteFile(file.id);
                      fileProvider.pickAndSaveFile(); // Refresh list
                      
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File renamed successfully')),
                      );
                    } else {
                      throw Exception('File not found');
                    }
                  } else {
                    // For files without path, update in provider
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('File renamed')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error renaming file: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(UserFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share File'),
        content: Text('Share "${file.name}" with others?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(UserFile file, FileProvider fileProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
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
                const SnackBar(content: Text('File deleted')),
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
