import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message from VC SBBU", style: TextStyle(color: ITColors.white),),
        backgroundColor: ITColors.backgroundbar, // Customize as per your theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rounded Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15), // Adjust the value for more or less rounding
              child: Image.asset(
                'assets/iconimages/vcsbbu.png', // Replace with the HOD's image path
                width: 120, // Define the width
                height: 120, // Define the height
                fit: BoxFit.cover, // Ensures the image fits within the defined size
              ),
            ),
            SizedBox(height: 20),

            // Message Title
            Text(
              "Message from the Voice chanceller (VC) – SBBU",
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
              "Name of VC\nDr Madad Ali Shah, \nShaheed Benazir Bhutto University",
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
