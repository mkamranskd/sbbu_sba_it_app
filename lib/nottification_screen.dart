import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF8BC9D5),
      body: Column(
        children: [
          // App Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: ITColors.bartext,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.notifications,
                  color: ITColors.iconbar,
                ),
              ],
            ),
          ),
          // Notifications List
          Expanded(
            child: ListView(
              children: [
                _notificationItem(
                  imageUrl: 'https://via.placeholder.com/49x49',
                  message: 'Ma’am Marina Sherbaz uploaded a slide on Cloud Computing',
                  timeAgo: '2 h ago',
                ),
                _notificationItem(
                  imageUrl: 'https://via.placeholder.com/49x49',
                  message: 'Dr. Miraj Nabi Bhatti posted a circular',
                  timeAgo: '5 h ago',
                ),
                // Add more notifications as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to create notification items
  Widget _notificationItem({required String imageUrl, required String message, required String timeAgo}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFCAE1F6),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: Color(0xFF070707),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
