import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int _length = 12;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';

  final _symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

  String generatePassword() {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    String chars = lowercase;
    if (_includeUppercase) chars += lowercase.toUpperCase();
    if (_includeNumbers) chars += '0123456789';
    if (_includeSymbols) chars += _symbols;

    if (chars.isEmpty) return '';

    final rand = Random.secure();
    return List.generate(_length, (_) => chars[rand.nextInt(chars.length)]).join('');
  }

  void _onGenerate() {
    setState(() {
      _generatedPassword = generatePassword();
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Generator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_generatedPassword.isNotEmpty) ...[
              SelectableText(
                _generatedPassword,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: Icon(Icons.copy),
                label: Text('Copy'),
                onPressed: _copyToClipboard,
              ),
              Divider(),
            ],
            Row(
              children: [
                Text('Length: $_length'),
                Expanded(
                  child: Slider(
                    value: _length.toDouble(),
                    min: 6,
                    max: 32,
                    divisions: 26,
                    label: _length.toString(),
                    onChanged: (val) {
                      setState(() {
                        _length = val.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Include Uppercase Letters'),
              value: _includeUppercase,
              onChanged: (val) => setState(() => _includeUppercase = val ?? true),
            ),
            CheckboxListTile(
              title: Text('Include Numbers'),
              value: _includeNumbers,
              onChanged: (val) => setState(() => _includeNumbers = val ?? true),
            ),
            CheckboxListTile(
              title: Text('Include Symbols'),
              value: _includeSymbols,
              onChanged: (val) => setState(() => _includeSymbols = val ?? true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onGenerate,
              child: Text('Generate Password'),
            ),
          ],
        ),
      ),
    );
  }
}
