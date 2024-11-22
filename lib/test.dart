import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SaveMessageScreen extends StatefulWidget {
  @override
  _SaveMessageScreenState createState() => _SaveMessageScreenState();
}

class _SaveMessageScreenState extends State<SaveMessageScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> saveMessage() async {
    // Save to Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('officialsMessages')
        .doc('personalities')
        .collection('messages')
        .add({
      'name': _nameController.text,
      'imageUrl': _imageUrlController.text,
      'postTitle': _postTitleController.text,
      'message': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(), // Automatically save current time
    }).then((value) {
      print('Message saved');
    }).catchError((error) {
      print('Failed to save message: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Save Official's Message")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: "Image URL"),
            ),
            TextField(
              controller: _postTitleController,
              decoration: InputDecoration(labelText: "Post Title"),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: "Message"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveMessage,
              child: Text("Save Message"),
            ),
          ],
        ),
      ),
    );
  }
}



class LoadMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Official's Messages")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('officialsMessages')
            .doc('personalities')
            .collection('messages')
            .orderBy('timestamp') // Order by timestamp to get ascending order
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages available.'));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              return MessageCard(
                name: message['name'],
                imageUrl: message['imageUrl'],
                postTitle: message['postTitle'],
                message: message['message'],
                documentId: message.id,  // Pass document ID here for deletion
              );
            },
          );
        },
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String postTitle;
  final String message;
  final String documentId;  // This is the ID of the message document in Firestore

  const MessageCard({
    required this.name,
    required this.imageUrl,
    required this.postTitle,
    required this.message,
    required this.documentId,  // Pass the document ID here
  });

  // Method to delete message from Firestore
  Future<void> deleteMessage(BuildContext context) async {
    try {
      // Delete the message document from Firestore
      await FirebaseFirestore.instance
          .collection('officialsMessages')
          .doc('personalities')
          .collection('messages')
          .doc(documentId)  // Use the document ID to target the specific message
          .delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Message deleted successfully'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting message: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(postTitle, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Spacer(),
                // Delete Button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Ask for confirmation before deleting the message
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text('Are you sure you want to delete this message?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      // If the user confirmed, delete the message
                      await deleteMessage(context);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
