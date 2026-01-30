import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String status;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      status: json['status'] ?? 'want_to_read',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'status': status,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'reading':
        return 'Reading';
      case 'completed':
        return 'Completed';
      case 'want_to_read':
        return 'Want to Read';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'reading':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'want_to_read':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'reading':
        return Icons.menu_book;
      case 'completed':
        return Icons.check_circle;
      case 'want_to_read':
        return Icons.bookmark;
      default:
        return Icons.book;
    }
  }
}