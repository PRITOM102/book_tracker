import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  String _selectedStatus = 'want_to_read';
  bool _isLoading = false;

  Future<void> _addBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService.addBook(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        status: _selectedStatus,
      );
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      _showError('Failed to add book');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Book Title',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Reading Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    RadioListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.bookmark, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Want to Read'),
                        ],
                      ),
                      value: 'want_to_read',
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value.toString());
                      },
                    ),
                    RadioListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.menu_book, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Currently Reading'),
                        ],
                      ),
                      value: 'reading',
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value.toString());
                      },
                    ),
                    RadioListTile(
                      title: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Completed'),
                        ],
                      ),
                      value: 'completed',
                      groupValue: _selectedStatus,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value.toString());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addBook,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Add Book',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}