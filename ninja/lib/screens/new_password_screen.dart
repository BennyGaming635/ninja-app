import 'package:flutter/material.dart';
import 'dart:math';

class NewPasswordScreen extends StatefulWidget {
  // Add username to onSave callback
  final Function(String name, String username, String password, String notes) onSave;

  NewPasswordScreen({required this.onSave});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(); // Add this
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  double _entropy = 0;
  String _strength = '';
  String _crackTime = '';

  void _analyzePassword(String password) {
    int charsetSize = 0;

    if (RegExp(r'[a-z]').hasMatch(password)) charsetSize += 26;
    if (RegExp(r'[A-Z]').hasMatch(password)) charsetSize += 26;
    if (RegExp(r'[0-9]').hasMatch(password)) charsetSize += 10;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) charsetSize += 32;

    charsetSize = max(charsetSize, 1);
    final entropy = password.length * (log(charsetSize) / ln2);

    setState(() {
      _entropy = entropy;
      _strength = _getStrengthLabel(entropy);
      _crackTime = _estimateCrackTime(entropy);
    });
  }

  String _getStrengthLabel(double entropy) {
    if (entropy < 28) return 'Very Weak';
    if (entropy < 36) return 'Weak';
    if (entropy < 60) return 'Reasonable';
    if (entropy < 128) return 'Strong';
    return 'Very Strong';
  }

  String _estimateCrackTime(double entropy) {
    double guesses = pow(2, entropy).toDouble();
    double guessesPerSecond = 1e9; // 1 billion guesses/sec

    double seconds = guesses / guessesPerSecond;

    if (seconds < 60) return '${seconds.toStringAsFixed(2)} seconds';
    if (seconds < 3600) return '${(seconds / 60).toStringAsFixed(2)} minutes';
    if (seconds < 86400) return '${(seconds / 3600).toStringAsFixed(2)} hours';
    if (seconds < 31536000) return '${(seconds / 86400).toStringAsFixed(2)} days';
    return '${(seconds / 31536000).toStringAsFixed(2)} years';
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _analyzePassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name (e.g., Gmail)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: _entropy / 128.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _entropy < 36
                    ? Colors.red
                    : _entropy < 60
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Strength: $_strength',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Estimated crack time: $_crackTime'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                final notes = _notesController.text.trim();

                if (name.isNotEmpty && password.isNotEmpty) {
                  widget.onSave(name, username, password, notes);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
