import 'package:flutter/material.dart';
import 'passwords_screen.dart';
import 'new_password_screen.dart';
import 'settings_screen.dart';
import 'password_generator_screen.dart';  // <- Add this import
import '../utils/storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalPasswords = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final passwords = await Storage.getPasswords();
    setState(() {
      totalPasswords = passwords.length;
    });
  }

  Future<void> _navigateAndRefresh(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ninja Vault')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Passwords: $totalPasswords', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              child: Text('View Passwords'),
              onPressed: () => _navigateAndRefresh(PasswordsScreen()),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('Add New Password'),
              onPressed: () => _navigateAndRefresh(NewPasswordScreen()),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('Settings'),
              onPressed: () => _navigateAndRefresh(SettingsScreen()),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('Password Generator'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PasswordGeneratorScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
