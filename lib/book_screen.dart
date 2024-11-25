import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/sizes.dart';
import 'package:sbbu_sba_it_app/utils/themeapp/custum_theme/text_theme.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class TimeTableScreen extends StatefulWidget {
  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  // Dropdown options
  final List<String> batches = ['21', '22', '23', '24'];
  final List<String> sections = ['A', 'B'];

  String? selectedBatch;
  String? selectedSection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tables'),
        backgroundColor: ITColors.primary, // Custom primary color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ITSizes.md), // Custom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Batch Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Batch",
                border: OutlineInputBorder(),
              ),
              value: selectedBatch,
              onChanged: (value) {
                setState(() {
                  selectedBatch = value;
                });
              },
              items: batches.map((String batch) {
                return DropdownMenuItem<String>(
                  value: batch,
                  child: Text(batch),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md), // Custom spacing

            // Section Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Section",
                border: OutlineInputBorder(),
              ),
              value: selectedSection,
              onChanged: (value) {
                setState(() {
                  selectedSection = value;
                });
              },
              items: sections.map((String section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
            ),
            SizedBox(height: ITSizes.md * 2), // Custom spacing

            // Display timetable image based on selection
            if (selectedBatch != null && selectedSection != null)
              Column(
                children: [
                  Text(
                    "Timetable for Batch $selectedBatch - Section $selectedSection",
                    style: ITTextTheme.lightTextTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: ITSizes.fontSizeLg, // Custom font size
                      color: ITColors.textPrimary, // Custom text color
                    ),
                  ),
                  SizedBox(height: ITSizes.md),
                  PinchZoom(
                    maxScale: 3,
                    child: Image.asset(
                      'assets/timetableimages/batch${selectedBatch!}${selectedSection!.toLowerCase()}.png', // Adjusted dynamic image path
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'Image not found for Batch $selectedBatch and Section $selectedSection.',
                        style: TextStyle(color: ITColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Text(
                  "Please select both Batch and Section to view the timetable.",
                  style: TextStyle(color: ITColors.textSecondary), // Custom text style
                ),
              ),
          ],
        ),
      ),
    );
  }
}
