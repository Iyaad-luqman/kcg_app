// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kcg_app/dashboard.dart';
import 'dart:ui';

import 'package:kcg_app/marks_display.dart';


class Marks extends StatefulWidget {
  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {

    int _selectedIndex = -1;


  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if(index == 0){
         Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    });
  }
Widget cardWidget(String title,double percentage, Widget routeBuilder) {
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
              Padding(
                padding: EdgeInsets.only(left: 20), // adjust the value as needed
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color.fromARGB(255, 94, 183, 255), // make the text blue
                      fontSize: 24, // make the text a little big
                    ),
                  ),
                ),
              ),
              Text(
                '$percentage%', // display the percentage
                style: TextStyle(
                  fontFamily: 'QuickSand',
                  fontSize: 32, // make the text bigger
                ),
              ),
              SizedBox(height: 10), // add some spacing
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 3,
                  width: 120,
                  child: LinearProgressIndicator(
                    value: percentage / 100, // calculate the progress
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(
                      percentage < 50 ? Colors.red : Color.fromARGB(255, 0, 162, 255), // set the color based on the percentage
                    ),
                  ),
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
    appBar: AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back), // back button
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Center(
    child: Text('Exam Results'), // replace 'Marks' with your desired title
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.refresh), // reload button
      onPressed: () {
        // Add your reload function here
      },
    ),
  ],
  backgroundColor: Colors.transparent,
  elevation: 0,
  flexibleSpace: ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 90, sigmaY: 130),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 31, 0, 102).withOpacity(0),
        ),
      ),
    ),
  ),
),
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
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 5),
                    child: Text(
                      'Choose the Exam:',
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
                          'Iyaad Luqman K ',
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
                      itemCount: 4, // number of items
                      itemBuilder: (context, index) {
                        // Define your data
                        List<double> percentage = [90, 80, 70, 20];
                        List<String> titles = ['CAT 1', 'CAT 2', 'CAT 3', 'CAT 4'];
                        List<Widget> routes = [MarksDisplay(exam_name: 'CAT 1'), MarksDisplay(exam_name: 'CAT 2'), MarksDisplay(exam_name: 'CAT 3'), MarksDisplay(exam_name: 'CAT 4')];

                        // Pass the data to the cardWidget function
                        return cardWidget(
                          titles[index],
                          percentage[index],
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
  currentIndex: _selectedIndex < 0 ? 0 : _selectedIndex,
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