import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/custombutton.dart';

class EditTimeTableScreen extends StatefulWidget {
  @override
  _EditTimeTableScreenState createState() => _EditTimeTableScreenState();
}

class _EditTimeTableScreenState extends State<EditTimeTableScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController teacherController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  // Selected dropdown values
  String? selectedDepartment;
  String? selectedBatch;
  String? selectedSection;
  String? selectedTime;
  String? selectedDay;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Track if editing and the document ID of the selected timetable record
  bool isEditing = false;
  String? editingDocId;

  // Save or update timetable to Firestore
  Future<void> saveOrUpdateTimeTable(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Add new or update existing record
        if (isEditing && editingDocId != null) {
          await _firestore.collection('timetable').doc(editingDocId).update({
            'department': selectedDepartment,
            'batch': selectedBatch,
            'section': selectedSection,
            'time': selectedTime,
            'day': selectedDay,
            'teacher': teacherController.text,
            'room': roomController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Timetable updated successfully!')),
          );
        } else {
          await _firestore.collection('timetable').add({
            'department': selectedDepartment,
            'batch': selectedBatch,
            'section': selectedSection,
            'time': selectedTime,
            'day': selectedDay,
            'teacher': teacherController.text,
            'room': roomController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Timetable saved successfully!')),
          );
        }
        // Reset form after saving or updating
        _resetForm();
      } catch (e) {
        debugPrint("Error saving timetable: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving timetable: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  // Function to delete a record from Firestore
  Future<void> deleteRecord(String id) async {
    try {
      await _firestore.collection('timetable').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully!')),
      );
    } catch (e) {
      debugPrint("Error deleting record: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting record: $e')),
      );
    }
  }

  // Load timetable records from Firestore
  Stream<QuerySnapshot> loadTimeTable() {
    return _firestore.collection('timetable').snapshots();
  }

  // Populate fields for editing a record
  void populateFieldsForEditing(DocumentSnapshot doc) {
    setState(() {
      selectedDepartment = doc['department'];
      selectedBatch = doc['batch'];
      selectedSection = doc['section'];
      selectedTime = doc['time'];
      selectedDay = doc['day'];
      teacherController.text = doc['teacher'];
      roomController.text = doc['room'];
      editingDocId = doc.id;
      isEditing = true;
    });
  }

  // Reset form fields
  void _resetForm() {
    setState(() {
      selectedDepartment = null;
      selectedBatch = null;
      selectedSection = null;
      selectedTime = null;
      selectedDay = null;
      teacherController.clear();
      roomController.clear();
      isEditing = false;
      editingDocId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Timetable" : "Add Timetable", style: TextStyle(color: ITColors.bartext),
        ),
      ),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Day Dropdown
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedDay,
                        hint: const Text('Select Day'),
                        items: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ].map((day) {
                          return DropdownMenuItem(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDay = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a day' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Department Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedDepartment,
                        hint: const Text('Select Department'),
                        items: [
                          'IT',
                          'BBA',
                          'Sindhi',
                          'Economics',
                          'Media'
                        ].map((department) {
                          return DropdownMenuItem(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartment = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a department' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Batch Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedBatch,
                        hint: const Text('Select Batch'),
                        items: ['21', '22', '23', '24'].map((batch) {
                          return DropdownMenuItem(
                            value: batch,
                            child: Text(batch),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedBatch = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a batch' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Section Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedSection,
                        hint: const Text('Select Section'),
                        items: ['A', 'B', 'C', 'D'].map((section) {
                          return DropdownMenuItem(
                            value: section,
                            child: Text(section),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSection = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a section' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Time Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedTime,
                        hint: const Text('Select Time'),
                        items: [
                          '9 AM - 10 AM',
                          '10 AM - 11 AM',
                          '11 AM - 12 PM',
                          '12 PM - 1 PM',
                          '1 PM - 2 PM'
                        ].map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                        validator: (value) =>
                        value == null ? 'Please select a time' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Teacher Field
                      TextFormField(
                        controller: teacherController,
                        decoration: const InputDecoration(
                          hintText: 'Teacher\'s Name',
                          filled: true,
                          fillColor: Color(0xFFF5FCF9),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter the teacher\'s name' : null,
                      ),
                      const SizedBox(height: 16.0),
                      // Room Field
                      TextFormField(
                        controller: roomController,
                        decoration: const InputDecoration(
                          hintText: 'Classroom Number',
                          filled: true,
                          fillColor: Color(0xFFF5FCF9),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter the classroom number' : null,
                      ),
                      const SizedBox(height: 24.0),
                      // Submit Button
                      CustomButton(
                        onPressed: () => saveOrUpdateTimeTable(context),
                        text: isEditing ? 'Update Timetable' : 'Save Timetable',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // Display Timetable Records
                StreamBuilder<QuerySnapshot>(
                  stream: loadTimeTable(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error loading timetable records.");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text("${data['department']} - ${data['batch']}"),
                            subtitle: Text(
                              "Section ${data['section']} | ${data['time']} | ${data['teacher']} | ${data['room']} | ${data['day']}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
          );
        }),
      ),
    );
  }
}
