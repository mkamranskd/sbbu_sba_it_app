import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class MessageScreenHOD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message from HOD",style: TextStyle(color: ITColors.white),),
        backgroundColor: ITColors.backgroundbar, // Customize as per your theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rounded Image
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/iconimages/mirajnabi.png'), // Replace with the HOD's image path
            ),
            SizedBox(height: 20),

            // Message Title
            Text(
              "Message from the Head of Department (HOD) – IT",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Message Body
            Text(
              "Education in Information Technology is not just about mastering the latest technologies but also about building a foundation of innovation, critical thinking, and teamwork. "
                  "As the Head of the Department, I am proud to lead a team dedicated to fostering creativity and technical excellence. "
                  "Our mission is to prepare students to face global challenges and contribute meaningfully to the ever-evolving IT industry.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Sansita',
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 30),

            // HOD Name
            Text(
              "[Name of HOD]\nHead of Department, IT\nShaheed Benazir Bhutto University",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
