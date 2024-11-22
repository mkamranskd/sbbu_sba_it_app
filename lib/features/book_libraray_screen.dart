import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/gallery_screen.dart';


class BookLibraryScreen extends StatelessWidget {
  final Category category;

  BookLibraryScreen({super.key, required this.category});

  final List<Book> books = [
    Book(title: 'Book Title 1', writer: 'Writer 1'),
    Book(title: 'Book Title 2', writer: 'Writer 2'),
    Book(title: 'Book Title 3', writer: 'Writer 3'),
    // Add more books here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => BookDetailDialog(book: book),
              );
            },
            child: Column(
              children: [
                Icon(Icons.book, size: 40),
                Text(book.title, textAlign: TextAlign.center),
                Text(book.writer, style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Book {
  final String title;
  final String writer;

  Book({required this.title, required this.writer});
}
class BookDetailDialog extends StatelessWidget {
  final Book book;

  BookDetailDialog({required this.book});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(book.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Author: ${book.writer}'),
          SizedBox(height: 10),
          Text('Description of the book goes here...'), // Add more details as needed
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Implement open functionality here
          },
          child: Text('Open'),
        ),
        TextButton(
          onPressed: () {
            // Implement download functionality here
          },
          child: Text('Download'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
