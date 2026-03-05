import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteLocationsPage extends StatefulWidget {
  @override
  _FavouriteLocationsPageState createState() => _FavouriteLocationsPageState();
}

class _FavouriteLocationsPageState extends State<FavouriteLocationsPage> {
  FlutterTts tts = FlutterTts();
  List<String> favouriteLocations = [];
  int selected = 0;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favouriteLocations = prefs.getStringList('favourite_locations') ?? [];
      if (favouriteLocations.isNotEmpty) _speak(favouriteLocations[0]);
    });
  }

  Future _speak(String text) async {
    await tts.setLanguage('en-IN');
    await tts.speak(text);
  }

  void _onSwipeRight() {
    if (favouriteLocations.isEmpty) return;
    setState(() {
      selected = (selected + 1) % favouriteLocations.length;
    });
    _speak(favouriteLocations[selected]);
  }

  void _onSwipeLeft() {
    if (favouriteLocations.isEmpty) return;
    setState(() {
      selected = (selected - 1 + favouriteLocations.length) % favouriteLocations.length;
    });
    _speak(favouriteLocations[selected]);
  }

  void _onDoubleTap() {
    if (favouriteLocations.isEmpty) return;
    _speak("Selected favourite: ${favouriteLocations[selected]}");
    // Here, in the future, you can start navigation etc.
  }

  void _onSwipeDown() {
    Navigator.of(context).maybePop();
    _speak("Going back");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _onSwipeRight();
            } else if (details.primaryVelocity! > 0) {
              _onSwipeLeft();
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! > 0) _onSwipeDown();
          },
          onDoubleTap: _onDoubleTap,
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Favourite Locations",
                  style: TextStyle(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18),
              Expanded(
                child: favouriteLocations.isEmpty
                    ? Center(
                  child: Text(
                    "No Favourites Added",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
                    : ListView.builder(
                  itemCount: favouriteLocations.length,
                  itemBuilder: (context, idx) {
                    bool isSelected = selected == idx;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 35),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.yellow : Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            favouriteLocations[idx],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 38),
            ],
          ),
        ),
      ),
    );
  }
}
