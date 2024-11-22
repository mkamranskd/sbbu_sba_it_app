import 'dart:math'; // For generating code
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/custombutton.dart';

class AdminClassroomScreen extends StatefulWidget {
  @override
  _AdminClassroomScreenState createState() => _AdminClassroomScreenState();
}

class _AdminClassroomScreenState extends State<AdminClassroomScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController teacherController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isEditing = false;
  String? editingDocId;

  // Method to generate a 6-digit code
  String generateCode() {
    return Random().nextInt(900000).toString().padLeft(6, '0'); // E.g., "123456"
  }

  // Save or update classroom and show generated code
  Future<void> saveOrUpdateClassroom(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String joinCode = generateCode(); // Generate the unique code

      try {
        if (isEditing && editingDocId != null) {
          await _firestore.collection('classrooms').doc(editingDocId).update({
            'teacher': teacherController.text,
            'department': departmentController.text,
            'batch': batchController.text,
            'section': sectionController.text,
            'subject': subjectController.text,
            'joinCode': joinCode,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Classroom updated successfully!')),
          );
        } else {
          await _firestore.collection('classrooms').add({
            'teacher': teacherController.text,
            'department': departmentController.text,
            'batch': batchController.text,
            'section': sectionController.text,
            'subject': subjectController.text,
            'joinCode': joinCode,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Classroom saved successfully!')),
          );
        }

        showJoinCodePopup(context, joinCode);
        _resetForm();
      } catch (e) {
        debugPrint("Error saving classroom: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving classroom: $e')),
        );
      }
    }
  }

  // Show a dialog with the join code and copy option
  void showJoinCodePopup(BuildContext context, String joinCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Classroom Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Share this code with students to join: $joinCode"),
              const SizedBox(height: 10),
              CustomButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: joinCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard')),
                  );
                },
                text:'Copy Code',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Reset form function
  void _resetForm() {
    setState(() {
      teacherController.clear();
      departmentController.clear();
      batchController.clear();
      sectionController.clear();
      subjectController.clear();

      isEditing = false;
      editingDocId = null;
    });
  }

  // Delete classroom function
  Future<void> deleteRecord(String docId) async {
    try {
      await _firestore.collection('classrooms').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Classroom deleted successfully!')),
      );
    } catch (e) {
      debugPrint("Error deleting classroom: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting classroom: $e')),
      );
    }
  }

  // Populate fields for editing
  void populateFieldsForEditing(DocumentSnapshot doc) {
    setState(() {
      isEditing = true;
      editingDocId = doc.id;
      teacherController.text = doc['teacher'];
      departmentController.text = doc['department'];
      batchController.text = doc['batch'];
      sectionController.text = doc['section'];
      subjectController.text = doc['subject'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Classroom' : 'Add Classroom', style: TextStyle(color: ITColors.textWhite),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Form fields for adding or editing classroom
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) => value!.isEmpty ? 'Please enter a department' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: batchController,
                decoration: const InputDecoration(labelText: 'Batch'),
                validator: (value) => value!.isEmpty ? 'Please enter a batch' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: sectionController,
                decoration: const InputDecoration(labelText: 'Section'),
                validator: (value) => value!.isEmpty ? 'Please enter a section' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) => value!.isEmpty ? 'Please enter a subject' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: teacherController,
                decoration: const InputDecoration(labelText: 'Teacher Name'),
                validator: (value) => value!.isEmpty ? 'Please enter teacher name' : null,
              ),
              const SizedBox(height: 20),

              // Save Classroom Button
              CustomButton(
                onPressed: () => saveOrUpdateClassroom(context),
                text: isEditing ? 'Update Class' : 'Save Classroom',
              ),
              const SizedBox(height: 32),

              // Show Classroom List (Edit, Delete, and Join Code within ListTile)
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('classrooms').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No classrooms available.'));
                  }

                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text("${data['department']} - ${data['batch']}"),
                          subtitle: Text(
                            "Section ${data['section']} | ${data['subject']} | ${data['teacher']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Code: ${data['joinCode']}"), // Display join code here
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => populateFieldsForEditing(doc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteRecord(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
