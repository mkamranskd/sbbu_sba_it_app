import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/class_detail.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({Key? key, required this.classModel}) : super(key: key);

  Stream<QuerySnapshot> getAnnouncements() {
    return FirebaseFirestore.instance
        .collection('announcements')
        .where('batch', isEqualTo: '21') // Replace '21' with dynamic batch
        .snapshots();
  }

  Stream<QuerySnapshot> getSlides() {
    return FirebaseFirestore.instance
        .collection('slides')
        .where('batch', isEqualTo: '21') // Replace '21' with dynamic batch
        .where('subject', isEqualTo: classModel.name) // Use dynamic subject
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(classModel.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Announcements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: getAnnouncements(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final announcements = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(announcements[index]['message']),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Slides',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: getSlides(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final slides = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      return ListTile(
                        title: Text(slide['fileName']),
                        onTap: () {
                          // Handle PDF view or download
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
