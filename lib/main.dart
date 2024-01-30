import 'package:flutter/material.dart';
import './splash.dart';

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
 
      home: SplashScreen(),
    );
  }
}
