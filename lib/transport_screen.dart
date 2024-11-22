import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class StudentTransportScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Details', style: TextStyle(color: ITColors.bartext),),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    title: Text(
                      "Point ${data['point'] ?? ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ITColors.textColor,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "Time: ${data['time'] ?? 'Not specified'}",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Pickup Area/Route: ${data['route'] ?? 'Not specified'}",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.directions_bus,
                      color: ITColors.primaryIcon,
                      size: 50,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
