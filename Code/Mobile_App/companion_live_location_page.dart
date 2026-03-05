import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class CompanionLiveLocationPage extends StatefulWidget {
  final String code;
  const CompanionLiveLocationPage({required this.code});

  @override
  _CompanionLiveLocationPageState createState() => _CompanionLiveLocationPageState();
}

class _CompanionLiveLocationPageState extends State<CompanionLiveLocationPage> {
  double? latitude, longitude;
  late DatabaseReference locationRef;
  StreamSubscription<DatabaseEvent>? locationSubscription;

  @override
  void initState() {
    super.initState();
    locationRef = FirebaseDatabase.instance.ref('users/${widget.code}/location');
    locationSubscription = locationRef.onValue.listen((event) {
      try {
        final data = event.snapshot.value;
        if (data != null && data is Map) {
          final map = Map<String, dynamic>.from(data);
          if (map.containsKey('lat') && map.containsKey('lng')) {
            setState(() {
              latitude = (map['lat'] as num).toDouble();
              longitude = (map['lng'] as num).toDouble();
            });
          }
        }
      } catch (e) {
        print('Error reading from Firebase: $e');
      }
    });
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng? userPosition = (latitude != null && longitude != null)
        ? LatLng(latitude!, longitude!)
        : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text("Blind User Live Location"),
          backgroundColor: Colors.black
      ),
      body: userPosition == null
          ? Center(child: Text("Waiting for location...", style: TextStyle(color: Colors.white, fontSize: 18)))
          : FlutterMap(
        options: MapOptions(
          center: userPosition,
          zoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            // Just remove the attributionBuilder/Widget line if error persists,
            // or if needed, use:
            // attributionWidget: Text("© OpenStreetMap contributors", style: TextStyle(color: Colors.black)),
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40,
                height: 40,
                point: userPosition,
                child: Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
