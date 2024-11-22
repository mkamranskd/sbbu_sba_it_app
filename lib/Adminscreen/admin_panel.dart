import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_classroom_screen.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_staff_screen.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_transport_screen.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_upload_event_image.dart';
import 'package:sbbu_sba_it_app/Adminscreen/time_table_admin.dart';
import 'package:sbbu_sba_it_app/Adminscreen/upload_books.dart';
import 'package:sbbu_sba_it_app/Adminscreen/admin_classroom.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart'; // Assuming your color constants are here
import 'package:sbbu_sba_it_app/utils/constant/it_icon_sizes.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'UPLOAD ITEMS',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account, color: Colors.black),
            onPressed: () {
              // Implement switch user functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            UploadMenu(
              text: "Classroom",
              icon: Icons.meeting_room,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUploadScreen(),
                  ),
                );
              },
            ),
            UploadMenu(
              text: "Timetable",
              icon: Icons.schedule,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTimeTableScreen(),
                  ),
                );
              },
            ),
            UploadMenu(
              text: "Books",
              icon: Icons.book,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadBooksScreen(),
                  ),
                );
              },
            ),
            UploadMenu(
              text: "About Staff",
              icon: Icons.admin_panel_settings,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminStaffScreen(),
                  ),
                );
              },
            ),

            UploadMenu(
              text: "Create Class",
              icon: Icons.create,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminClassroomScreen(),
                  ),
                );
              },
            ),
            UploadMenu(
              text: "Gallery",
              icon: Icons.image,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminEventScreen(),
                  ),
                );
              },
            ),
            UploadMenu(
              text: "Busses Details",
              icon: Icons.bus_alert,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminTransportScreen(),
                  ),
                );
              },
            ),

            // Add more UploadMenu items as needed
          ],
        ),
      ),
    );
  }
}

class UploadMenu extends StatelessWidget {
  const UploadMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: ITColors.primaryIcon, // Updated with icon color constant
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: ITColors.primaryIcon, // Updated with icon color constant
              size: ITIconSizes.iconSizeMedium, // Apply icon size constant
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
