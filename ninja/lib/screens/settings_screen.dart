import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'debug_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _developerMode = false;
  bool _advancedExpanded = false;

  static const _version = 'v1.5';

  @override
  void initState() {
    super.initState();
    _loadDevMode();
  }

  Future<void> _loadDevMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _developerMode = prefs.getBool('developerMode') ?? false;
    });
  }

  Future<void> _setDevMode(bool value) async {
    if (value == true) {
      // Show warning dialog first
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning: Developer Mode'),
          content: Text(
            'Enabling developer mode exposes internal details and debugging features. '
            'Improper use may cause data loss or unexpected behavior. '
            'Do you want to continue?',
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text('Enable'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
      if (confirm != true) {
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('developerMode', value);
    setState(() {
      _developerMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text('Developer Mode'),
            subtitle: Text(
              'Toggle developer mode to enable advanced debugging features.',
            ),
            value: _developerMode,
            onChanged: _setDevMode,
          ),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _advancedExpanded = !_advancedExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text('Advanced'),
                  );
                },
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Version: $_version'),
                      SizedBox(height: 16),
                      if (_developerMode) ...[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DebugScreen()),
                            );
                          },
                          child: Text('Open Debug Screen'),
                        ),
                      ] else
                        Text(
                          'Enable Developer Mode to access debug features.',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                isExpanded: _advancedExpanded,
                canTapOnHeader: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
