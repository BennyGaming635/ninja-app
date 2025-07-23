import 'package:flutter/material.dart';
import '../models/password.dart';
import '../utils/storage.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _noteController = TextEditingController();

  void _save() async {
    if (_nameController.text.isEmpty || _passController.text.isEmpty) return;
    final entry = PasswordEntry.create(
      name: _nameController.text,
      username: _userController.text,
      password: _passController.text,
      notes: _noteController.text,
    );
    await Storage.savePassword(entry);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Service Name')),
            TextField(controller: _userController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passController, decoration: InputDecoration(labelText: 'Password')),
            TextField(controller: _noteController, decoration: InputDecoration(labelText: 'Notes')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
