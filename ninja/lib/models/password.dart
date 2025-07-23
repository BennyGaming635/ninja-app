import 'package:uuid/uuid.dart';

class PasswordEntry {
  final String id;
  final String name;
  final String username;
  final String password;
  final String notes;

  PasswordEntry({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.notes,
  });

  factory PasswordEntry.create({required String name, required String username, required String password, String notes = ''}) {
    return PasswordEntry(
      id: const Uuid().v4(),
      name: name,
      username: username,
      password: password,
      notes: notes,
    );
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'password': password,
        'notes': notes,
      };
}
