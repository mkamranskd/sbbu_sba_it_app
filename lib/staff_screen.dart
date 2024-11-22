import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_staff_screen.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ITColors.barbackground,

    appBar: AppBar(
      backgroundColor: ITColors.barbackground,
        title: const Text('Staff Information - IT Department', style: TextStyle(
            color: ITColors.bartext // Set the color of the text
        ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings,color: ITColors.iconbar),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminStaffScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return StaffCard(staff: staff);
          },
        ),
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Staff staff;

  const StaffCard({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(staff.photoUrl),
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        staff.position,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Education: ${staff.educationLevel}"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // See More Button that opens a dialog
            TextButton(
              onPressed: () {
                _showMoreDetails(context);
              },
              child: const Text('See More'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(staff.name),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Position: ${staff.position}"),
              Text("Education: ${staff.educationLevel}"),
              Text("Biography: ${staff.bio}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
