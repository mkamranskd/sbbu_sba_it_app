import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ProfileHeader(), // ProfileHeader contains the profile icon and membership bar
          ProfileField(
            label: 'Name',
            value: 'Syed Jafar Abbas Shah',
            onEdit: () {},
          ),
          ProfileField(
            label: 'Email',
            value: '21bsit99@student.sbbusba.edu.pk',
            onEdit: () {},
          ),
          ProfileField(
            label: 'Department',
            value: 'Information Technology',
            onEdit: () {},
          ),
          ProfileField(
            label: 'Batch',
            value: '21',
            onEdit: () {},
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'LOG OUT',
              style: TextStyle(
                color: Color(0xFF4C6ED7),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFA64141), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // MembershipPlan appears right after the profile icon
        Text(
          'Syed Jafar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Syed Jafar Abbas Shah',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 7),
        MembershipPlan(),
      ],
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const ProfileField({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color(0xFFFDFDFD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.black),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 10, color: Color(0xFF4F4F4F)),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 12, color: Color(0xFF4F4F4F)),
            ),
          ),
        ],
      ),
    );
  }
}

class MembershipPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlanOption(
          label: 'Membership Plan',
          value: 'Student',
          isSelected: true,
        ),
        PlanOption(
          label: 'Gold Plan',
          value: 'Staff',
          isSelected: false,
        ),
      ],
    );
  }
}

class PlanOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;

  const PlanOption({
    required this.label,
    required this.value,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        color: isSelected ? Color(0xFFDFE2F8) : Color(0xFFD9D9D9),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Color(0xFF4F4F4F) : Colors.black,
          ),
        ),
      ),
    );
  }
}
