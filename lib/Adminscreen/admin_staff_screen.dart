import 'package:flutter/material.dart';

// Staff model and sample data
class Staff {
  final String name;
  final String position;
  final String educationLevel;
  final String bio;
  final String photoUrl;

  Staff({
    required this.name,
    required this.position,
    required this.educationLevel,
    required this.bio,
    required this.photoUrl,
  });
}

List<Staff> staffList = [
  Staff(
    name: "Dr. Mairaj Nabi",
    position: "HOD",
    educationLevel: "PhD in Information Technology",
    bio: "Dr. Mairaj Nabi is an experienced academic with a passion for AI research...",
    photoUrl: "https://example.com/alice_photo.jpg",
  ),
  Staff(
    name: "Prof. Mark Green",
    position: "Professor",
    educationLevel: "MSc in Information Technology",
    bio: "Professor Mark Green has over 20 years of experience in teaching software development...",
    photoUrl: "https://example.com/mark_photo.jpg",
  ),
];

class AdminStaffScreen extends StatefulWidget {
  const AdminStaffScreen({Key? key}) : super(key: key);

  @override
  _AdminStaffScreenState createState() => _AdminStaffScreenState();
}

class _AdminStaffScreenState extends State<AdminStaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin - Staff Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return StaffCard(
              staff: staff,
              onEdit: () => _openEditDialog(context, staff),
              onDelete: () => _deleteStaff(context, staff),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add New Staff Member',
      ),
    );
  }

  void _openAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StaffFormDialog(
        onSave: (newStaff) {
          setState(() {
            staffList.add(newStaff);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openEditDialog(BuildContext context, Staff staff) {
    showDialog(
      context: context,
      builder: (context) => StaffFormDialog(
        staff: staff,
        onSave: (updatedStaff) {
          setState(() {
            final index = staffList.indexOf(staff);
            staffList[index] = updatedStaff;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteStaff(BuildContext context, Staff staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this staff member?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                staffList.remove(staff);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class StaffCard extends StatelessWidget {
  final Staff staff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StaffCard({
    Key? key,
    required this.staff,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                  Text(
                    "Education: ${staff.educationLevel}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(onPressed: onEdit, child: const Text("Edit")),
                      TextButton(onPressed: onDelete, child: const Text("Delete")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StaffFormDialog extends StatefulWidget {
  final Staff? staff;
  final void Function(Staff) onSave;

  const StaffFormDialog({Key? key, this.staff, required this.onSave}) : super(key: key);

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _position;
  late String _educationLevel;
  late String _bio;
  late String _photoUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.staff?.name ?? '';
    _position = widget.staff?.position ?? '';
    _educationLevel = widget.staff?.educationLevel ?? '';
    _bio = widget.staff?.bio ?? '';
    _photoUrl = widget.staff?.photoUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.staff == null ? "Add Staff Member" : "Edit Staff Member"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: "Name"),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? "Enter a name" : null,
              ),
              TextFormField(
                initialValue: _position,
                decoration: const InputDecoration(labelText: "Position"),
                onSaved: (value) => _position = value!,
                validator: (value) => value!.isEmpty ? "Enter a position" : null,
              ),
              TextFormField(
                initialValue: _educationLevel,
                decoration: const InputDecoration(labelText: "Education Level"),
                onSaved: (value) => _educationLevel = value!,
              ),
              TextFormField(
                initialValue: _bio,
                decoration: const InputDecoration(labelText: "Biography"),
                onSaved: (value) => _bio = value!,
              ),
              TextFormField(
                initialValue: _photoUrl,
                decoration: const InputDecoration(labelText: "Photo URL"),
                onSaved: (value) => _photoUrl = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSave(
                Staff(
                  name: _name,
                  position: _position,
                  educationLevel: _educationLevel,
                  bio: _bio,
                  photoUrl: _photoUrl,
                ),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
