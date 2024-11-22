import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/custombutton.dart';

class UploadBooksScreen extends StatefulWidget {
  const UploadBooksScreen({super.key});

  @override
  _UploadBooksScreenState createState() => _UploadBooksScreenState();
}

class _UploadBooksScreenState extends State<UploadBooksScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  String? selectedCategory;
  String? selectedDepartment;
  String? selectedBatch;
  String? uploadedFileUrl;
  bool isEditing = false;
  String? editingDocId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to pick a PDF file and upload it to Firebase Storage
  Future<void> pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path!);

      // Define Firebase Storage location
      String fileName = result.files.single.name;
      Reference storageRef = FirebaseStorage.instance.ref().child('books/$fileName');

      // Upload file to Firebase Storage
      try {
        await storageRef.putFile(file);
        // Get the file URL after upload
        uploadedFileUrl = await storageRef.getDownloadURL();
        setState(() {});  // Refresh UI to reflect the uploaded file URL
      } catch (e) {
        debugPrint("File upload error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> saveOrUpdateBook(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (isEditing && editingDocId != null) {
          await _firestore.collection('books').doc(editingDocId).update({
            'category': selectedCategory,
            'department': selectedDepartment,
            'batch': selectedBatch,
            'title': titleController.text,
            'file_url': uploadedFileUrl,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book updated successfully!')),
          );
        } else {
          await _firestore.collection('books').add({
            'category': selectedCategory,
            'department': selectedDepartment,
            'batch': selectedBatch,
            'title': titleController.text,
            'file_url': uploadedFileUrl,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book uploaded successfully!')),
          );
        }
        _resetForm();
      } catch (e) {
        debugPrint("Error saving book: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving book: $e')),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      selectedCategory = null;
      selectedDepartment = null;
      selectedBatch = null;
      titleController.clear();
      uploadedFileUrl = null;
      isEditing = false;
      editingDocId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Book" : "Upload Book",
          style: TextStyle(fontWeight: FontWeight.bold, color: ITColors.textWhite),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: _formKey,
            child: Column(

              children: [
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: const Text('Select Category'),
                  items: ['Cyber Security', 'Networking', 'Mathematics', 'DLD', 'InfraStructure']
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  hint: const Text('Select Department'),
                  items: ['IT', 'BBA', 'Sindhi', 'Economics', 'Media']
                      .map((department) => DropdownMenuItem(value: department, child: Text(department)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a department' : null,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedBatch,
                  hint: const Text('Select Batch'),
                  items: ['21', '22', '23', '24'].map((batch) => DropdownMenuItem(value: batch, child: Text(batch))).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBatch = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a batch' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Book Title',
                    filled: true,
                    fillColor: Color(0xFFF5FCF9),
                    contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter the book title' : null,
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  onPressed: pickAndUploadFile,
                  text: uploadedFileUrl == null ? 'Upload File' : 'File Uploaded',
                  ),
                const SizedBox(height: 16.0),
                CustomButton(
                  onPressed: () => saveOrUpdateBook(context),
                  text: isEditing ? "Update Book" : "Upload Book",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
