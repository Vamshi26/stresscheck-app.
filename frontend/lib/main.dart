import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String apiBase = 'https://stresscheck-backend.onrender.com';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: const Text('Stress Checker')), body: StressForm()));
  }
}

class StressForm extends StatefulWidget { @override _StressFormState createState() => _StressFormState(); }

class _StressFormState extends State<StressForm> {
  final TextEditingController _controller = TextEditingController();
  String result = '';
  Future<void> checkStress() async {
    final response = await http.post(Uri.parse('${MyApp.apiBase}/api/check_stress'),
      headers: {'Content-Type': 'application/json'}, body: json.encode({'text': _controller.text}));
    if (response.statusCode == 200) { setState(() { result = json.decode(response.body)['stress_level']; }); }
    else { setState(() { result = 'Error: ${response.statusCode}'; }); }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Enter how you feel')),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: checkStress, child: const Text('Check Stress')),
      const SizedBox(height: 16), Text(result)
    ]));
  }
}
