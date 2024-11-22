import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class DownloadScreen extends StatelessWidget {
  final List<Map<String, String>> downloads = [
    {"title": "Thesis Format", "url": "assets/files/thesis_format.pdf"},
    {"title": "Assignment Design Front Page", "url": "assets/files/assignment_design.pdf"},
    {"title": "Scholarship Form", "url": "assets/files/scholarship_form.pdf"},
    {"title": "Student Form", "url": "assets/files/student_form.pdf"},
    {"title": "Supply Form", "url": "assets/files/supply_form.pdf"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads", style: TextStyle(color: ITColors.white)),
        backgroundColor: ITColors.backgroundbar,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: downloads.length,
        itemBuilder: (context, index) {
          final download = downloads[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.download, color: Colors.blueAccent),
              title: Text(
                download["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showDownloadDialog(context, download["title"]!, download["url"]!);
              },
            ),
          );
        },
      ),
    );
  }

  void _showDownloadDialog(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Download $title"),
          content: const Text("Would you like to download this file?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startDownload(context, url, title);
              },
              child: const Text("Download"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startDownload(BuildContext context, String url, String fileName) async {
    try {
      // Check and request permission
      if (await Permission.storage.request().isGranted) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final filePath = "${directory.path}/$fileName";
          final dio = Dio();

          // Show progress dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          // Download the file
          await dio.download(url, filePath);

          // Dismiss progress dialog
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Downloaded to: $filePath")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss progress dialog if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
