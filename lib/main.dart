import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './splash.dart';
import './dashboard.dart'; // import your DashboardScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'KCG College of Technology',
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        // Initialize SharedPreferences
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen(); // Show splash screen while reading preferences
          }
          var name = snapshot.data?.getString('name');
          var regno = snapshot.data?.getString('regno');
          // Check if name and regno are not null
          if (name != null && regno != null) {
            return Dashboard(); // If not null, go to DashboardScreen
          } else {
            return SplashScreen(); // If null, go to SplashScreen
          }
        },
      ),
    );
  }
}