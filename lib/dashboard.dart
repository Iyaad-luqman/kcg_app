// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kcg_app/attendance.dart';
import 'package:kcg_app/feedback.dart';
import 'package:kcg_app/fees.dart';
import 'package:kcg_app/library.dart';
import 'package:kcg_app/marks.dart';
import 'package:kcg_app/receipts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Profile Page'),
  ];


String? name;
String? semester;

@override
void initState() {
  super.initState();
  _loadNameAndSemester();
}

void _loadNameAndSemester() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    name = prefs.getString('name');
    semester = prefs.getString('semno');
  });
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
Widget cardWidget(String title, String imagePath, Widget routeBuilder) {
  return InkWell(
    onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => routeBuilder));
    },
    child: Card(
      color: Color.fromARGB(255,17, 5, 44).withOpacity(0.2), // make the Card semi-transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 7,
      margin: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 70, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Color.fromARGB(5,40, 43, 91).withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(imagePath, width: 70, height: 70,), // display the image
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue, // make the text blue
                  ),
                ),
               

              ],
            ),
          ),
        ),
      ),
    ),
  );
}
@override
Widget build(BuildContext context) {
  double hlen = MediaQuery.of(context).size.height;
  double wlen = MediaQuery.of(context).size.width;

  return Scaffold(
    body: Stack(
      children: [
        Container(
          height: hlen,
          width: wlen,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/Dashboard.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 0, 5),
                    child: Text(
                      // 'Welcome, $name',
                      'Welcome, Iyaad Luqman K',
                      style: TextStyle(fontSize: 23, fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                    ),
                  ),
                   Row(
                     children: [
                      SizedBox(
                        width: 20,
                      ),
                       Image.asset('images/cap.png', width: 40, height: 40,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: Text(
                          '1st Semester',
                          // '$semester' ,
                          style: TextStyle(fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                        ),
                                         ),
                     ],
                   ),
                  // Add a GridView.builder
                  Container(
                    height: hlen * 0.7, // specify the height of the GridView
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items per row
                      ),
                      itemCount: 6, // number of items
                      itemBuilder: (context, index) {
                        // Define your data
                        List<String> icons = ['images/attendance.png' ,'images/fees.png', 'images/marks.png' ,'images/library.png' ,'images/feedback.png' , 'images/reciept.png'];
                        List<String> titles = ['Attendance', 'Fees', 'Exam Results', 'Library', 'FeedBack', 'Receipts'];
                        List<Widget> routes = [Attendance(), Fees(), Marks(), Library(), FeedBack(), Receipts()];

                        // Pass the data to the cardWidget function
                        return cardWidget(
                          titles[index],
                          icons[index],
                          routes[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(30.0),
            //   topRight: Radius.circular(30.0),
            // ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 130),
              child: BottomNavigationBar(
  backgroundColor: Color.fromARGB(255, 31, 0, 102).withOpacity(0), // make the BottomNavigationBar semi-transparent
  items: <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Container(
        decoration: _selectedIndex == 0
            ? BoxDecoration(
                boxShadow: [
                 BoxShadow(
                    color: Colors.blue,

                    blurRadius: 20.0, // adjust the blur radius
                    spreadRadius: 2.0, // adjust the spread radius
                  ),
                ],
              )
            : null,
        child: Image.asset('images/home.png', height: 30, width: 30,), // replace with your custom icon
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Container(
        decoration: _selectedIndex == 1
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,

                    blurRadius: 20.0, // adjust the blur radius
                    spreadRadius: 2.0, // adjust the spread radius
                  ),
                ],
              )
            : null,
        child: Image.asset('images/timetable.png', height: 30, width: 30,), // replace with your custom icon
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Container(
        decoration: _selectedIndex == 2
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 20.0, // adjust the blur radius
                    spreadRadius: 2.0, // adjust the spread radius
                  ),
                ],
              )
            : null,
        child: Image.asset('images/profile.png', height: 30, width: 30,), // replace with your custom icon
      ),
      label: '',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.amber[800],
  onTap: _onItemTapped,
  showSelectedLabels: false, // do not show labels for selected items
  showUnselectedLabels: false, // do not show labels for unselected items
),
            ),
          ),
        ),
      ],
    ),
  );
}
}