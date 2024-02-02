import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kcg_app/dashboard.dart';
import 'package:kcg_app/splash.dart';
import 'package:kcg_app/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Profile Page'),
  ];

  String? name;
  String? semester;
  String? regno;
  String? batchyr;
  String? depno;


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
      regno = prefs.getString('regno');
      batchyr = prefs.getString('batchyr');
      depno =   prefs.getString('depno');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Timetable()));
      }
      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }

  Widget cardWidget(String title, String imagePath, Widget routeBuilder) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => routeBuilder));
      },
      child: Card(
        color: Color.fromARGB(255, 17, 5, 44)
            .withOpacity(0.2), // make the Card semi-transparent
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
              color: Color.fromARGB(5, 40, 43, 91).withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: 70,
                    height: 70,
                  ), // display the image
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50.0), // Adjust the value as needed
            child: Text('Profile'),
          ), // replace 'Marks' with your desired title
        ),
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
                      height: 80,
                    ),

                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'images/avatar.png',
                          width: 180,
                          height: 170,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        '$name',
                        // 'Iyaad Luqman K',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        // 'Welcome, $name',
                        'Regno: ${regno}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        // 'Welcome, $name',
                        'Batch: ${batchyr}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: wlen * 0.26,
                          ),
                          Image.asset(
                            'images/cap.png',
                            width: 40,
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '${semester}st Semester',
                              // '$semester' ,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        label: Text('Logout'),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()));
                        },
                      ),
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
                          // List<String> icons = ['images/attendance.png' ,'images/fees.png', 'images/marks.png' ,'images/library.png' ,'images/feedback.png' , 'images/reciept.png'];
                          // List<String> titles = ['Attendance', 'Fees', 'Exam Results', 'Library', 'FeedBack', 'Receipts'];
                          // List<Widget> routes = [Attendance(), Fees(), Marks(), Library(), FeedBack(), Receipts()];

                          // Pass the data to the cardWidget function
                          // return cardWidget(
                          //   titles[index],
                          //   icons[index],
                          //   routes[index],
                          // );
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
                  backgroundColor: Color.fromARGB(255, 31, 0, 102).withOpacity(
                      0), // make the BottomNavigationBar semi-transparent
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Container(
                        decoration: _selectedIndex == 0
                            ? BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue,

                                    blurRadius: 20.0, // adjust the blur radius
                                    spreadRadius:
                                        2.0, // adjust the spread radius
                                  ),
                                ],
                              )
                            : null,
                        child: Image.asset(
                          'images/home.png',
                          height: 30,
                          width: 30,
                        ), // replace with your custom icon
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
                                    spreadRadius:
                                        2.0, // adjust the spread radius
                                  ),
                                ],
                              )
                            : null,
                        child: Image.asset(
                          'images/timetable.png',
                          height: 30,
                          width: 30,
                        ), // replace with your custom icon
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
                                    spreadRadius:
                                        2.0, // adjust the spread radius
                                  ),
                                ],
                              )
                            : null,
                        child: Image.asset(
                          'images/profile.png',
                          height: 30,
                          width: 30,
                        ), // replace with your custom icon
                      ),
                      label: '',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                  showSelectedLabels:
                      false, // do not show labels for selected items
                  showUnselectedLabels:
                      false, // do not show labels for unselected items
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
