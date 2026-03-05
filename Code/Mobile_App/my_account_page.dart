import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  String? companionCode;

  @override
  void initState() {
    super.initState();
    _loadOrGenerateCode();
  }

  Future<void> _loadOrGenerateCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCode = prefs.getString('companion_code');
    if (storedCode == null) {
      storedCode = (Random().nextInt(900000) + 100000).toString();
      await prefs.setString('companion_code', storedCode);
    }
    setState(() {
      companionCode = storedCode;
    });
  }

  void _onCompanionDoubleTap() {
    setState(() {
      // Optionally re-generate code on double tap, if needed
      companionCode = (Random().nextInt(900000) + 100000).toString();
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('companion_code', companionCode!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Companion Code: ${companionCode!}",
          style: TextStyle(fontSize: 18),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Account"), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('My Account', style: TextStyle(fontSize: 26, color: Colors.white)),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: _onCompanionDoubleTap,
                      child: Text(
                        "Guardian / Companion Access",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 18),
                    if (companionCode != null)
                      SelectableText(
                        "Companion Code: $companionCode",
                        style: TextStyle(color: Colors.black, fontSize: 18,
                            fontWeight: FontWeight.bold, letterSpacing: 2),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              // Add account or device info below as needed
            ],
          ),
        ),
      ),
    );
  }
}
