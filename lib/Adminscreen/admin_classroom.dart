import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AdminUploadScreen extends StatefulWidget {
  @override
  _AdminUploadScreenState createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKeyAnnouncement = GlobalKey<FormState>();
  final _formKeySlide = GlobalKey<FormState>();
  final TextEditingController announcementController = TextEditingController();
  PlatformFile? selectedFile;
  String? selectedBatchForAnnouncement;
  String? selectedBatchForSlide;
  String? selectedSubject;

  // Announcement upload method
  Future<void> uploadAnnouncement() async {
    if (_formKeyAnnouncement.currentState!.validate() && selectedBatchForAnnouncement != null) {
      final announcementText = announcementController.text.trim();

      try {
        await FirebaseFirestore.instance.collection('announcements').add({
          'message': announcementText,
          'batch': selectedBatchForAnnouncement,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement uploaded successfully!')),
        );

        announcementController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading announcement: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a batch and enter a message')),
      );
    }
  }

  // File picker for PDF
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  // Slide upload method
  Future<void> uploadFile() async {
    if (selectedFile == null || selectedBatchForSlide == null || selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields and select a file.')),
      );
      return;
    }

    final fileName = selectedFile!.name;
    final filePath = selectedFile!.path;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('slides/$fileName');
      await storageRef.putFile(File(filePath!));

      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('slides').add({
        'fileUrl': downloadUrl,
        'fileName': fileName,
        'batch': selectedBatchForSlide,
        'subject': selectedSubject,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully!')),
      );

      setState(() {
        selectedFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Announcement Form
            Form(
              key: _formKeyAnnouncement,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Announcement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: announcementController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Announcement Message',
                      border: OutlineInputBorder(),
                      hintText: 'Enter announcement message',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Batch',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedBatchForAnnouncement,
                    onChanged: (value) => setState(() => selectedBatchForAnnouncement = value),
                    items: ['21', '22', '23', '24']
                        .map((batch) => DropdownMenuItem(value: batch, child: Text(batch)))
                        .toList(),
                    validator: (value) => value == null ? 'Please select a batch' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: uploadAnnouncement,
                    child: const Text('Send Announcement with Notification'),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),

            // Slide Upload Form
            Form(
              key: _formKeySlide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload PDF Slide',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: pickFile,
                    child: Text(selectedFile == null ? 'Select PDF Slide' : 'File Selected: ${selectedFile!.name}'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Batch',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedBatchForSlide,
                    onChanged: (value) => setState(() => selectedBatchForSlide = value),
                    items: ['21', '22', '23', '24']
                        .map((batch) => DropdownMenuItem(value: batch, child: Text(batch)))
                        .toList(),
                    validator: (value) => value == null ? 'Please select a batch' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Subject',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSubject,
                    onChanged: (value) => setState(() => selectedSubject = value),
                    items: ['Math', 'Science', 'History', 'English']
                        .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
                        .toList(),
                    validator: (value) => value == null ? 'Please select a subject' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: uploadFile,
                    child: const Text('Upload PDF Slide'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
