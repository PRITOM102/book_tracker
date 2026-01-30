import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book_model.dart';

class SupabaseService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // Get all books for current user
  static Future<List<Book>> getBooks() async {
    try {
      final response = await supabase
          .from('books')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((book) => Book.fromJson(book))
          .toList();
    } catch (error) {
      print('Error fetching books: $error');
      rethrow;
    }
  }

  // Add a new book
  static Future<void> addBook({
    required String title,
    required String author,
    required String status,
  }) async {
    try {
      await supabase.from('books').insert({
        'title': title,
        'author': author,
        'status': status,
        'user_id': supabase.auth.currentUser!.id,
      });
    } catch (error) {
      print('Error adding book: $error');
      rethrow;
    }
  }

  // Update book status
  static Future<void> updateBookStatus(String bookId, String newStatus) async {
    try {
      await supabase
          .from('books')
          .update({'status': newStatus})
          .eq('id', bookId);
    } catch (error) {
      print('Error updating book status: $error');
      rethrow;
    }
  }

  // Delete a book
  static Future<void> deleteBook(String bookId) async {
    try {
      await supabase
          .from('books')
          .delete()
          .eq('id', bookId);
    } catch (error) {
      print('Error deleting book: $error');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      rethrow;
    }
  }

  // Get current user
  static User? get currentUser => supabase.auth.currentUser;
}