import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import '../utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.init();
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
