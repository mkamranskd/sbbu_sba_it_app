import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/class_room.dart';


class ClassListScreen extends StatelessWidget {
  final List<ClassModel> classes = [
    ClassModel(id: '1', name: 'Cyber Security', description: 'Introduction to CS'),
    // Add more classes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classroom',style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classData = classes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDetailScreen(classModel: classData),
                  ),
                );
              },
              child: Card(
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    classData.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClassModel {
  final String id;
  final String name;
  final String description;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
  });
}
