import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

class DebugScreen extends StatefulWidget {
  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _storagePath = '';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadStoragePath();
    _loadLogs();
  }

  Future<void> _loadStoragePath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      setState(() {
        _storagePath = dir.path;
      });
    } catch (e) {
      setState(() {
        _storagePath = 'Failed to get storage path: $e';
      });
    }
  }

  Future<void> _loadLogs() async {
    final logs = await AppLogger.getLogs();
    setState(() {
      _logs = logs;
    });
  }

  void _forceCrash() {
    throw StateError('Forced crash triggered by developer mode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Storage Path:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(_storagePath),
            SizedBox(height: 20),
            Text(
              'Logs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Text(_logs[index]);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _forceCrash,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Force Crash'),
            ),
          ],
        ),
      ),
    );
  }
}
