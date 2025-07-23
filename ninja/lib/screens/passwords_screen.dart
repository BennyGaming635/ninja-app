import 'package:flutter/material.dart';
import '../models/password.dart';
import '../utils/storage.dart';
import 'password_info_screen.dart';

class PasswordsScreen extends StatefulWidget {
  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  List<PasswordEntry> allPasswords = [];
  List<PasswordEntry> filteredPasswords = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPasswords();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPasswords = allPasswords.where((entry) {
        return entry.name.toLowerCase().contains(query) ||
               entry.username.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _loadPasswords() async {
    final data = await Storage.getPasswords();
    setState(() {
      allPasswords = data;
      filteredPasswords = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Passwords')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search passwords',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredPasswords.isEmpty
                ? Center(child: Text('No passwords found'))
                : ListView.builder(
                    itemCount: filteredPasswords.length,
                    itemBuilder: (context, index) {
                      final entry = filteredPasswords[index];
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
          ),
        ],
      ),
    );
  }
}
