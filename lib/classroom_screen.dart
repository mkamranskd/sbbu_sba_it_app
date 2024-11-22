import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class ClassroomScreen extends StatefulWidget {
  @override
  _ClassroomScreenState createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController classCodeController = TextEditingController();

  // To store the list of joined classes
  List<Map<String, dynamic>> joinedClasses = [];

  // Method to handle class code entry
  void showJoinClassPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Class Code'),
          content: TextField(
            controller: classCodeController,
            decoration: const InputDecoration(labelText: 'Class Code'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                String enteredCode = classCodeController.text;
                if (enteredCode.isNotEmpty) {
                  joinClass(enteredCode);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Join'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle class joining logic
  void joinClass(String classCode) {
    _firestore.collection('classrooms').where('joinCode', isEqualTo: classCode).get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Check if this class code has already been joined
        if (joinedClasses.any((classItem) => classItem['joinCode'] == classCode)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have already joined this class.')),
          );
          return;
        }

        // Class exists and not joined before, add class to the list
        setState(() {
          joinedClasses.add(querySnapshot.docs.first.data() as Map<String, dynamic>);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the class!')),
        );
      } else {
        // Class code does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid class code!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Classrooms',
          style: TextStyle(color: ITColors.bartext),
        ),
        backgroundColor: ITColors.barbackground,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showJoinClassPopup,
        child: const Icon(Icons.add),
      ),
      body: joinedClasses.isEmpty
          ? const Center(child: Text('No classes joined.'))
          : ListView.builder(
        itemCount: joinedClasses.length,
        itemBuilder: (context, index) {
          final classData = joinedClasses[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          classData['teacherPhotoUrl'] ?? 'https://via.placeholder.com/150'),
                      radius: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classData['teacher'],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            classData['department'],
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Batch: ${classData['batch']}"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Class Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Section: ${classData['section']}'),
                      Text('Room: ${classData['room']}'),
                      Text('Day: ${classData['day']}'),
                      Text('Time: ${classData['time']}'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _showMoreDetails(context, classData);
                  },
                  child: const Text('See More'),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMoreDetails(BuildContext context, Map<String, dynamic> classData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Class Full Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Department: ${classData['department']}'),
              Text('Batch: ${classData['batch']}'),
              Text('Section: ${classData['section']}'),
              Text('Teacher: ${classData['teacher']}'),
              Text('Room: ${classData['room']}'),
              Text('Day: ${classData['day']}'),
              Text('Time: ${classData['time']}'),
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
}
