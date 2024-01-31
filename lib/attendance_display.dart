import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:kcg_app/dashboard.dart';
import 'package:kcg_app/circ.dart';


class AttendanceDisplay extends StatefulWidget {
  @override
  final int index;
  _AttendanceDisplayState createState() => _AttendanceDisplayState();
    AttendanceDisplay({required this.index});

}

class _AttendanceDisplayState extends State<AttendanceDisplay> {
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
Widget cardWidget(String title,int percentage) {
  return InkWell(
  
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
                      fontSize: 14, // make the text a little big
                    ),
                  ),
                ),
              ),
              Text(
                '$percentage', // display the percentage
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
                      percentage < 50 ? Color.fromARGB(255, 0, 162, 255) : Color.fromARGB(255, 0, 162, 255), // set the color based on the percentage
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
    double percentage  = 89.0;
  return Scaffold(
    appBar: AppBar(
  leading: IconButton(
    icon: Icon(Icons.arrow_back), // back button
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Center(
    child: Text('Attendance Analytics'), // replace 'Marks' with your desired title
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

                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        GradientCircularProgressIndicator(
                            key: Key('myProgressIndicator'),
                          value: percentage / 100, // calculate the progress
                          strokeWidth: 7.0,
                          radius: 90.0,
                          gradient1: LinearGradient(
                            colors: [Colors.white,Colors.white],
                          ),
                          gradient2: LinearGradient(
                            colors: [const Color.fromARGB(255, 191, 54, 100), Color.fromARGB(255,108, 46, 107), Color.fromARGB(255, 35, 38, 112)],
                          ),
                        ),
                        Text(
                          '${(percentage).toStringAsFixed(0)}%', // display the percentage191, 54, 100)
                          style: TextStyle(
                            fontSize: 24, // adjust the font size as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                      child: Text(
                        'Overall Attendance',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 31, fontFamily: 'ManRope', fontWeight: FontWeight.w300),
                      ),
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
                          'Engineering Physics ',
                          style: TextStyle(fontSize: 16, fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                        ),
                                         ),
                     ],
                   ),
                    
                  Card(

    color: Color.fromARGB(255,17, 5, 44).withOpacity(0.2), // make the Card semi-transparent
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 7,
    margin: EdgeInsets.all(20),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 10),
        child: Container(
          alignment: Alignment.center,
          color: Color.fromARGB(5,40, 43, 91).withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Row(
                children: [
                                Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0), // adjust the value as needed
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attendance Status:',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Color.fromARGB(255, 94, 183, 255), // make the text blue
                      fontSize: 15, // make the text a little big
                    ),
                  ),
                ),
              ),
                  SizedBox(width: 10), // add some spacing

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: percentage > 75 ? Icon(Icons.check_circle, color: Colors.green, size: 20,) :  Icon(Icons.cancel, color: Colors.red, size: 20,),
                  ),
                ],
              ), 
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0), // adjust the value as needed
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No. of leaves you can take in this sem: 7', // display the percentage
                    style: TextStyle(
                      fontFamily: 'QuickSand',
                      fontSize: 15, // make the text bigger
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // add some spacing

            ],
          ),
        ),
      ),
    ),
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
                        List<int> percentage = [90, 80, 70, 20];
                        List<String> titles = ['Total Classes: ', 'Attended Classes: ', 'Missed Classes:', 'Remaining Classes: '];

                        // Pass the data to the cardWidget function
                        return cardWidget(
                          titles[index],
                          percentage[index],
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