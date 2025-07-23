import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(NinjaApp());

class NinjaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ninja',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool? _isPinSet;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPinSet = prefs.getString('pin') != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPinSet == null) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return _isPinSet! ? LockScreen() : SetupPinScreen();
  }
}

class SetupPinScreen extends StatefulWidget {
  @override
  _SetupPinScreenState createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final _controller = TextEditingController();

  Future<void> _savePin() async {
    if (_controller.text.length == 4) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pin', _controller.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter 4-digit PIN'),
              obscureText: true,
            ),
            ElevatedButton(onPressed: _savePin, child: Text('Save PIN'))
          ],
        ),
      ),
    );
  }
}
