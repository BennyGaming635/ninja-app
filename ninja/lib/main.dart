import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(NinjaApp());
}

class NinjaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ninja',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
