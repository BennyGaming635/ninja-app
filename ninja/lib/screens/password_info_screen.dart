import 'package:flutter/material.dart';
import '../models/password.dart';
import '../utils/storage.dart';

class PasswordInfoScreen extends StatelessWidget {
  final PasswordEntry entry;

  const PasswordInfoScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${entry.username}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Password: ${entry.password}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Notes: ${entry.notes}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                await Storage.deletePassword(entry.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
