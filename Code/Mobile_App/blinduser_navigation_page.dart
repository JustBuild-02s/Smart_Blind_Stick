import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

class BlindUserNavigationPage extends StatefulWidget {
  @override
  BlindUserNavigationPageState createState() => BlindUserNavigationPageState();
}

class BlindUserNavigationPageState extends State<BlindUserNavigationPage> {
  late FlutterTts _tts;
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _speech = stt.SpeechToText();
    _promptDestination();
  }

  Future<void> _promptDestination() async {
    await _tts.speak("Where do you want to go?");
    await Future.delayed(Duration(seconds: 2));
    _listenForDestination();
  }

  void _listenForDestination() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (result) {
        if (result.finalResult) {
          final destination = result.recognizedWords;
          _speech.stop();
          _tts.speak("Opening navigation to $destination");
          _launchNavigation(destination);
        }
      });
    } else {
      await _tts.speak("Speech recognition is not available.");
    }
  }

  Future<void> _launchNavigation(String destination) async {
    if (destination.isEmpty) {
      await _tts.speak("Destination not recognized. Please try again.");
      return;
    }

    String encodedDestination = Uri.encodeComponent(destination);
    Uri? uri;
    Uri? fallbackUri;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      uri = Uri.parse('http://maps.apple.com/?daddr=$encodedDestination&dirflg=w'); // Apple Maps app
      fallbackUri = Uri.parse('https://maps.apple.com/?daddr=$encodedDestination&dirflg=w'); // web fallback
    } else {
      uri = Uri.parse('google.navigation:q=$encodedDestination&mode=w'); // Google Maps app
      fallbackUri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$encodedDestination&travelmode=walking'); // web fallback
    }

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Navigation app launched
      } else if (await launchUrl(fallbackUri, mode: LaunchMode.externalApplication)) {
        // Fallback web link launched
      } else {
        await _tts.speak("Could not launch navigation app.");
      }
    } catch (e) {
      await _tts.speak("An error occurred while launching navigation.");
      print("Navigation launch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Navigation")),
      body: Center(child: Text("Listening for destination and launching navigation...")),
    );
  }
}
