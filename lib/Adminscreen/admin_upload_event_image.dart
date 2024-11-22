import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/custombutton.dart';

class AdminEventScreen extends StatefulWidget {
  @override
  _AdminEventScreenState createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDetailsController = TextEditingController(); // New controller for event details
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<File> images = [];

  // Function to pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  // Function to upload images with event name and details to Firestore
  Future<void> uploadEvent() async {
    if (eventNameController.text.isEmpty || eventDetailsController.text.isEmpty || images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an event name, details, and select images")),
      );
      return;
    }

    String eventName = eventNameController.text;
    String eventDetails = eventDetailsController.text;
    List<String> imageUrls = [];

    for (var image in images) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef = _storage.ref().child('events/$eventName/$imageName');
      await storageRef.putFile(image);
      String downloadUrl = await storageRef.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    await _firestore.collection('events').add({
      'eventName': eventName,
      'eventDetails': eventDetails, // Added event details field to Firestore
      'images': imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Event uploaded successfully!")),
    );

    // Clear the fields after uploading
    setState(() {
      eventNameController.clear();
      eventDetailsController.clear();
      images.clear();
    });
  }

  // Function to delete an event and its images
  Future<void> deleteEvent(String docId, List<String> imageUrls) async {
    try {
      for (var url in imageUrls) {
        await _storage.refFromURL(url).delete();
      }
      await _firestore.collection('events').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting event: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin: Upload Events", style: TextStyle(color: ITColors.bartext)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: eventDetailsController,
              decoration: InputDecoration(labelText: 'Event Details'), // New text field for event details
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: Icon(Icons.image),
              label: Text("Pick Images"),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: images.map((image) => Image.file(image, width: 80, height: 80)).toList(),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: uploadEvent,
              text:"Upload Event",
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('events').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No events uploaded."));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      List<String> imageUrls = List<String>.from(data['images']);
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(data['eventName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['eventDetails'] ?? "No details provided"), // Display event details
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: imageUrls.map((url) {
                                  return Image.network(url, width: 80, height: 80, fit: BoxFit.cover);
                                }).toList(),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteEvent(doc.id, imageUrls),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
