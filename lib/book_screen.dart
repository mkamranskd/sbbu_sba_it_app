import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/sizes.dart';
import 'package:sbbu_sba_it_app/utils/themeapp/custum_theme/text_theme.dart';


class TimeTableScreen extends StatefulWidget {
  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> departments = [];
  List<String> batches = [];
  List<String> sections = [];
  List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  String? selectedDepartment;
  String? selectedBatch;
  String? selectedSection;
  String? selectedDay;

  Stream<QuerySnapshot>? _timetableStream;

  @override
  void initState() {
    super.initState();
    fetchDropdownValues();
  }

  Future<void> fetchDropdownValues() async {
    try {
      final departmentSnapshot = await _firestore.collection('timetable').get();
      setState(() {
        departments = departmentSnapshot.docs.map((doc) => doc['department'] as String).toSet().toList();
        batches = departmentSnapshot.docs.map((doc) => doc['batch'] as String).toSet().toList();
        sections = departmentSnapshot.docs.map((doc) => doc['section'] as String).toSet().toList();
      });
    } catch (error) {
      print("Error fetching dropdown values: $error");
    }
  }

  void fetchTimetable() {
    if (selectedDepartment != null && selectedBatch != null && selectedSection != null && selectedDay != null) {
      setState(() {
        _timetableStream = _firestore
            .collection('timetable')
            .where('department', isEqualTo: selectedDepartment)
            .where('batch', isEqualTo: selectedBatch)
            .where('section', isEqualTo: selectedSection)
            .where('day', isEqualTo: selectedDay)
            .snapshots();
      });
    } else {
      setState(() {
        _timetableStream = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tables'),
        backgroundColor: ITColors.primary, // Applying custom primary color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ITSizes.md), // Applying custom padding
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Department",
                border: OutlineInputBorder(),
              ),
              value: selectedDepartment,
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                  fetchTimetable();
                });
              },
              items: departments.map((String department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md), // Applying custom spacing

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Batch",
                border: OutlineInputBorder(),
              ),
              value: selectedBatch,
              onChanged: (value) {
                setState(() {
                  selectedBatch = value;
                  fetchTimetable();
                });
              },
              items: batches.map((String batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md), // Applying custom spacing

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Section",
                border: OutlineInputBorder(),
              ),
              value: selectedSection,
              onChanged: (value) {
                setState(() {
                  selectedSection = value;
                  fetchTimetable();
                });
              },
              items: sections.map((String section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md), // Applying custom spacing

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Day",
                border: OutlineInputBorder(),
              ),
              value: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                  fetchTimetable();
                });
              },
              items: days.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md), // Applying custom spacing

            Center(
              child: Text(
                "Timings",
                style: ITTextTheme.lightTextTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: ITSizes.fontSizeLg, // Applying custom font size
                  color: ITColors.textPrimary, // Applying custom text color
                ),
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: _timetableStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: ITColors.accent)); // Custom progress indicator color
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: ITColors.textSecondary)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No records found.',
                      style: TextStyle(color: ITColors.textSecondary), // Custom text color
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(
                        "${doc['batch']} ${doc['section']} - ${doc['day']}",
                        style: ITTextTheme.lightTextTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: ITSizes.fontSizeLg,
                          color: ITColors.textPrimary, // Custom text color
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Teacher: ${doc['teacher']}", style: ITTextTheme.lightTextTheme.bodyMedium!.copyWith(color: ITColors.textSecondary)),
                          Text("Room: ${doc['room']}", style: ITTextTheme.lightTextTheme.bodyMedium!.copyWith(color: ITColors.textSecondary)),
                          Text("Time: ${doc['time']}", style: ITTextTheme.lightTextTheme.bodyMedium!.copyWith(color: ITColors.textSecondary)),
                        ],
                      ),
                      leading: Icon(Icons.schedule, color: ITColors.accent),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
