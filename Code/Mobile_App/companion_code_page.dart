import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'companion_live_location_page.dart'; // The page showing live location on map

class CompanionCodePage extends StatefulWidget {
  @override
  _CompanionCodePageState createState() => _CompanionCodePageState();
}

class _CompanionCodePageState extends State<CompanionCodePage> {
  final TextEditingController codeController = TextEditingController();
  final FlutterTts tts = FlutterTts();

  Future<void> _speak(String text) async {
    await tts.setLanguage('en-IN');
    await tts.speak(text);
  }

  void _onConnect() {
    String code = codeController.text.trim();
    if (code.isNotEmpty) {
      _speak("Connecting to code $code");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompanionLiveLocationPage(code: code),
        ),
      );
    } else {
      _speak("Please enter a valid code");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid code")),
      );
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Enter Companion Code"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter code shared by the blind user to track live location.",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: codeController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white24,
                labelText: "Companion Code",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onConnect,
              child: Text('Connect', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
