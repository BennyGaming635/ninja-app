import 'package:flutter/material.dart';
import '../models/password.dart';
import '../utils/storage.dart';
import 'password_info_screen.dart';

class PasswordsScreen extends StatefulWidget {
  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  List<PasswordEntry> passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  void _loadPasswords() async {
    final data = await Storage.getPasswords();
    setState(() {
      passwords = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Passwords')),
      body: ListView.builder(
        itemCount: passwords.length,
        itemBuilder: (context, index) {
          final entry = passwords[index];
          return ListTile(
            title: Text(entry.name),
            subtitle: Text(entry.username),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PasswordInfoScreen(entry: entry),
              ),
            ),
          );
        },
      ),
    );
  }
}
