import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'features/book_libraray_screen.dart';

class GalleryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(name: 'Networking', imageUrl: 'https://cdn-icons-png.freepik.com/512/3145/3145765.png', bookCount: 10),
    Category(name: 'Languages', imageUrl: 'assets/images/languages.jpg', bookCount: 15),
    Category(name: 'Islamic', imageUrl: 'assets/images/islamic.jpg', bookCount: 12),
    Category(name: 'Networking', imageUrl: 'assets/images/networking.jpg', bookCount: 10),
    Category(name: 'Languages', imageUrl: 'assets/images/languages.jpg', bookCount: 15),
    Category(name: 'Islamic', imageUrl: 'assets/images/islamic.jpg', bookCount: 12),
    // Add more categories here with proper image paths
  ];

  GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Categories', style: TextStyle(color: ITColors.bartext),)),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Three books per row
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjust height to width ratio
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookLibraryScreen(category: category),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      category.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${category.bookCount} Books', style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Category {
  final String name;
  final String imageUrl;
  final int bookCount;

  Category({required this.name, required this.imageUrl, required this.bookCount});
}