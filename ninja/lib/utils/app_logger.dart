import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  static final List<String> _logs = [];
  static File? _logFile;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File('${dir.path}/app_logs.txt');

    if (await _logFile!.exists()) {
      final content = await _logFile!.readAsString();
      _logs.addAll(content.split('\n').where((line) => line.isNotEmpty));
    } else {
      await _logFile!.create();
    }
  }

  static Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final entry = '[$timestamp] $message';
    _logs.add(entry);

    if (_logFile != null) {
      try {
        await _logFile!.writeAsString('$entry\n', mode: FileMode.append);
      } catch (e) {
        print('Failed to write log: $e');
      }
    }
  }

  static Future<List<String>> getLogs() async {
    if (_logFile == null) {
      await init();
    }
    return List.unmodifiable(_logs);
  }

  static Future<void> clearLogs() async {
    _logs.clear();
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString('');
    }
  }
}
