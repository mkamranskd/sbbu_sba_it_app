import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/custombutton.dart';

class AdminTransportScreen extends StatefulWidget {
  @override
  _AdminTransportScreenState createState() => _AdminTransportScreenState();
}

class _AdminTransportScreenState extends State<AdminTransportScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text controllers for form fields
  final TextEditingController pointController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController routeController = TextEditingController();

  bool isEditing = false;
  String? editingDocId;

  // Save or update transport details
  Future<void> saveOrUpdateTransportDetail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (isEditing && editingDocId != null) {
          // Update existing record
          await _firestore.collection('transportDetails').doc(editingDocId).update({
            'point': pointController.text,
            'time': timeController.text,
            'route': routeController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transport detail updated successfully!')),
          );
        } else {
          // Add new record
          await _firestore.collection('transportDetails').add({
            'point': pointController.text,
            'time': timeController.text,
            'route': routeController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transport detail added successfully!')),
          );
        }
        _resetForm();
      } catch (e) {
        debugPrint("Error saving transport detail: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transport detail: $e')),
        );
      }
    }
  }

  // Reset form fields
  void _resetForm() {
    setState(() {
      pointController.clear();
      timeController.clear();
      routeController.clear();
      isEditing = false;
      editingDocId = null;
    });
  }

  // Delete transport record
  Future<void> deleteRecord(String docId) async {
    try {
      await _firestore.collection('transportDetails').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transport detail deleted successfully!')),
      );
    } catch (e) {
      debugPrint("Error deleting transport detail: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting transport detail: $e')),
      );
    }
  }

  // Populate fields for editing a record
  void populateFieldsForEditing(DocumentSnapshot doc) {
    setState(() {
      isEditing = true;
      editingDocId = doc.id;
      pointController.text = doc['point'];
      timeController.text = doc['time'];
      routeController.text = doc['route'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Transport Detail' : 'Add Transport Detail', style: const TextStyle(color: ITColors.bartext)),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: pointController,
                decoration: const InputDecoration(labelText: 'Point Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a point number' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) => value!.isEmpty ? 'Please enter a time' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: routeController,
                decoration: const InputDecoration(labelText: 'Pickup Area / Route'),
                validator: (value) => value!.isEmpty ? 'Please enter a pickup area or route' : null,
              ),
              const SizedBox(height: 16),

              // Save or Update Button
              CustomButton(
                onPressed: () => saveOrUpdateTransportDetail(context),
                text: isEditing ? 'Update Detail' : 'Save Details'
              ),

              const SizedBox(height: 16),

              // Display the list of transport details
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('transportDetails').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No transport details available.'));
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(data['point'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Time: ${data['time']}"),
                                Text("Route: ${data['route']}"),
                              ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
