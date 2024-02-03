import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:kcg_app/dashboard.dart';
import 'package:kcg_app/profile.dart';
import 'package:kcg_app/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarksDisplay extends StatefulWidget {
  final String exam_name;

  MarksDisplay({required this.exam_name});
  
  @override
  _MarksDisplayState createState() => _MarksDisplayState();
}

class _MarksDisplayState extends State<MarksDisplay> {

  int _selectedIndex = -1;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Search Page'),
    Text('Profile Page'),
  ];

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

Future<List<List<dynamic>>> _fetchData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonData = prefs.getString('data');
  if (jsonData == null || jsonData.isEmpty || jsonData == '' || jsonData == '[]') {
   Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
    return [[]];
  } else {
    return (jsonDecode(jsonData) as List).cast<List<dynamic>>();
  }
}


Widget cardWidget(String title,double percentage) {
  return InkWell(
// Set the height as needed
      child: Card(
    
      color: Color.fromARGB(255,17, 5, 44).withOpacity(0.2), // make the Card semi-transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 7,
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: ClipRRect(
  borderRadius: BorderRadius.circular(30.0),
  child: ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 70, sigmaY: 10),
      child: Container(
  alignment: Alignment.center,
  color: Color.fromARGB(5,40, 43, 91).withOpacity(0.1),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 60, // adjust the width as needed
              height: 60, // adjust the height as needed
              child: CircularProgressIndicator(
                value: percentage / 100, // calculate the progress
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(
                  percentage < 50 ? Colors.red : Color.fromARGB(255, 0, 162, 255), // set the color based on the percentage
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${percentage == -100 ? 0 : percentage.toStringAsFixed(0)}',// display the percentage
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18, // adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                  
                  
                ),
                Text(
                  '/100', // display the percentage
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 8, // adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                  
                  
                ),
              ],
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  color: Color.fromARGB(255, 94, 183, 255), // make the text blue
                  fontSize: 21, // make the text a little big
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  percentage < 0 ? 'ABSENT' : (percentage < 50 ? 'FAIL' : 'PASS'),
                  style: TextStyle(
                    fontFamily: 'QuickSand',
                    fontSize: 13, // make the text smaller
                  ),
                ),
                SizedBox(
                  width: 5,),
                percentage < 50
                  ? Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 15,
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 15,
                    ),
              ],
            ),
          ],
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.all(20),
      //   child: Image.asset(
      //     percentage < 50 ? 'images/fail.png' : 'assetspass.png', // set the image based on the percentage
      //   ),
      // ),
            
              ],
            ),
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
  return FutureBuilder<List<List<dynamic>>>(
    future: _fetchData(),
    builder: (BuildContext context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      } else if (snapshot.hasError) {
        return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
      } else {
        List<List<dynamic>> data = snapshot.data!;
        List<double> percentage = [];
List<String> titles = [];


for (var semesterData in data) {
  if (semesterData.length > 1 && semesterData[1] is List) {
    String fullTitle = semesterData[0] as String;
    String modifiedTitle = fullTitle.replaceAll('Semester', 'Sem');

    // Only process this semesterData if it matches widget.exam_name
    if (modifiedTitle == widget.exam_name) {
      List<dynamic> values = semesterData[1] as List<dynamic>;
      for (var element in values) {
        if (element is List && element.length > 2) {
          String value = element[2].toString();
          double? number;
          if (value == "Absent") {
            number = -100;
          } else {
            number = double.tryParse(value);
          }
          if (number != null) {
            percentage.add(number);
          }

          String? title = element[1].toString();
          if (title != null) {
            titles.add(title);
          }
         
        }
      }
    }
  }
}

int count = titles.length;

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
  child: Text('${widget.exam_name} Results'),
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
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 5),
                    child: Text(
                      '${widget.exam_name} : ',
                      style: TextStyle(fontSize: 36, fontFamily: 'ManRope', fontWeight: FontWeight.w300),
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
                          '1st Semester ',
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
                        crossAxisCount: 1, // number of items per row
                        childAspectRatio: 3.3, //// item width and height ratio
                      ),
                      itemCount: count, // number of items
                      itemBuilder: (context, index) {
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
    },
  );

}
}