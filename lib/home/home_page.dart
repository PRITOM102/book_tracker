import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book_model.dart';
import '../services/supabase_service.dart';
import '../widgets/book_card.dart';
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> _books = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    try {
      _books = await SupabaseService.getBooks();
    } catch (error) {
      _showError('Failed to load books');
    } finally {
      setState(() => _isLoading = false);
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

  Future<void> _signOut() async {
    try {
      await SupabaseService.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      _showError('Failed to sign out');
    }
  }

  Future<void> _deleteBook(String bookId) async {
    try {
      await SupabaseService.deleteBook(bookId);
      await _loadBooks();
    } catch (error) {
      _showError('Failed to delete book');
    }
  }

  Future<void> _updateBookStatus(Book book, String newStatus) async {
    try {
      await SupabaseService.updateBookStatus(book.id, newStatus);
      await _loadBooks();
    } catch (error) {
      _showError('Failed to update book status');
    }
  }

  List<Book> get _filteredBooks {
    if (_selectedFilter == 'all') return _books;
    return _books.where((book) => book.status == _selectedFilter).toList();
  }

  int _getBookCount(String status) {
    if (status == 'all') return _books.length;
    return _books.where((book) => book.status == status).length;
  }

  void _showStatusDialog(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.blue),
              title: const Text('Reading'),
              onTap: () {
                Navigator.pop(context);
                _updateBookStatus(book, 'reading');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Completed'),
              onTap: () {
                Navigator.pop(context);
                _updateBookStatus(book, 'completed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.orange),
              title: const Text('Want to Read'),
              onTap: () {
                Navigator.pop(context);
                _updateBookStatus(book, 'want_to_read');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Books'),
          actions: [
            IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              final filters = ['all', 'reading', 'completed', 'want_to_read'];
              setState(() => _selectedFilter = filters[index]);
            },
            tabs: [
              Tab(text: 'All (${_getBookCount('all')})'),
              Tab(text: 'Reading (${_getBookCount('reading')})'),
              Tab(text: 'Completed (${_getBookCount('completed')})'),
              Tab(text: 'Want to Read (${_getBookCount('want_to_read')})'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _selectedFilter == 'all'
                              ? 'No books found'
                              : 'No ${_selectedFilter.replaceAll('_', ' ')} books',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text( // Fixed: removed 'const'
                          'Tap + to add a new book',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadBooks,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return BookCard(
                          book: book,
                          onDelete: () => _deleteBook(book.id),
                          onStatusChange: () => _showStatusDialog(book),
                        );
                      },
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBookPage(),
              ),
            );
            await _loadBooks();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}