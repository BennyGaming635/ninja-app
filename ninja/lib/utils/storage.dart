import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/password.dart';
import '../utils/app_logger.dart';

class Storage {
  static const String key = 'ninja_passwords';

  static Future<List<PasswordEntry>> getPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) {
      AppLogger.log('No passwords found in storage.');
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    AppLogger.log('Loaded ${jsonList.length} passwords from storage.');
    return jsonList.map((e) => PasswordEntry.fromJson(e)).toList();
  }

  static Future<void> savePassword(PasswordEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final passwords = await getPasswords();
    passwords.add(entry);
    final jsonString = jsonEncode(passwords.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonString);
    AppLogger.log('Saved new password entry with id: ${entry.id}');
  }

  static Future<void> deletePassword(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final passwords = await getPasswords();
    passwords.removeWhere((e) => e.id == id);
    final jsonString = jsonEncode(passwords.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonString);
    AppLogger.log('Deleted password entry with id: $id');
  }
}

