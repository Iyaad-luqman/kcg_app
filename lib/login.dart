// ignore_for_file: prefer_const_constructors



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kcg_app/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _regsiter_controller = TextEditingController();

  final TextEditingController _dob_controller = TextEditingController();

Future login(String username, String password) async {
   final prefs = await SharedPreferences.getInstance();
  final url = 'http://studentlogin.kcgcollege.ac.in';
  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.6099.71 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Referer': 'http://studentlogin.kcgcollege.ac.in/',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9',
  };
  final body = '__EVENTTARGET=&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%2FwEPDwUKLTg2ODkwMDI5NQ9kFgICAw9kFgoCAw8QDxYGHg1EYXRhVGV4dEZpZWxkBQhjb2xsbmFtZR4ORGF0YVZhbHVlRmllbGQFDGNvbGxlZ2VfY29kZR4LXyFEYXRhQm91bmRnZBAVARlLQ0cgQ29sbGVnZSBvZiBUZWNobm9sb2d5FQECMTMUKwMBZxYBZmQCBQ8QZBAVAgtSb2xsIE51bWJlchFSZWdpc3RlcmVkIE51bWJlchUCATABMRQrAwJnZxYBAgFkAgcPD2QWBB4LcGxhY2Vob2xkZXIFEVJlZ2lzdGVyZWQgTnVtYmVyHgxhdXRvY29tcGxldGUFA29mZmQCCw8PZBYCHwQFA29mZmQCDw8PFgIeB1Zpc2libGVoZGRkVGTXEWkyJ%2FWMj4QNaVxx4miBw8LjRwBUqW%2FxWeqCSkc%3D&__VIEWSTATEGENERATOR=CA0B0334&__EVENTVALIDATION=%2FwEdAAeoMw5oUf6Bx7qoookBEHen1ewWtm3evXPJ0S9N%2F1pup%2FolUdBTEtKbUYVn9qLUVnP36l7NJf9XLe0xTP1byily7ATayzSAKKfWGUr2Dqcb%2BZxpWckI3qdmfEJVCu2f5cHN%2BDvxnwFeFeJ9MIBWR6934vHvarPjiaE44I2KpHcf1yDl%2FtX9t7eeyi4U5XVAg1o%3D&rblOnlineAppLoginMode=1&txtuname=$username&txtpassword=$password&Button1=Login';
  final response = await http.post(Uri.parse(url), headers: headers, body: body);
  
  final sessionId = response.headers['set-cookie']?.split(';').firstWhere((s) => s.startsWith('ASP.NET_SessionId=')).split('=')[1];
  
  final redirectUrl = RegExp(r'href="([^"]+)"').firstMatch(response.body)?.group(1);
  
  final response2 = await http.get(Uri.parse(url + redirectUrl!), headers: {...headers, 'Cookie': 'ASP.NET_SessionId=$sessionId'});
  
  await prefs.setString('sessionId', sessionId!);
  await prefs.setString('redirectUrl', redirectUrl);

  final name = RegExp(r'<span id="lblsname" class="ddl-lbl" style="">([^<]+)</span>').firstMatch(response2.body)?.group(1);
  await prefs.setString('name', name!);
  final regno = RegExp(r'<span id="Label15" class="ddl-lbl" style="">([^<]+)</span>').firstMatch(response2.body)?.group(1);
  await prefs.setString('name', regno!);
  final depno = RegExp(r'<span id="lbldegree" class="ddl-lbl" style="">([^<]+)</span>').firstMatch(response2.body)?.group(1);
  await prefs.setString('name', depno!);
  final semno = RegExp(r'<span id="lblsem" class="ddl-lbl" style="">([^<]+)</span>').firstMatch(response2.body)?.group(1);
  await prefs.setString('name', semno!);
  final batchyr = RegExp(r'<span id="lblyear" class="ddl-lbl" style="">([^<]+)</span>').firstMatch(response2.body)?.group(1);
  await prefs.setString('name', batchyr!);
  

  debugPrint('NAMMEEE -----------------> >>> > > > > > >> > >  > > > $name');

  if (regno != username ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('Login Details Incorrect'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

}

  @override
  Widget build(BuildContext context) {
    double hlen = MediaQuery.of(context).size.height;
    double wlen = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
  resizeToAvoidBottomInset: true, // Add this line
  body: SingleChildScrollView(
    child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text(
                  'Student Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(
                        -20, 0), // Moves the widget 10 pixels to the left
                    child: Icon(Icons.person_3)
                  ),
                  SizedBox(
                    height: hlen * 0.045,
                    width: wlen * 0.62,
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: _regsiter_controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(150, 42, 65, 82),
                          hintText: 'Register Number',
                          contentPadding: EdgeInsets.only(
                              left: 20, top: 0, bottom: 30, right: 20),
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Manrope',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w100,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                      offset: Offset(
                          -20, 0), // Moves the widget 10 pixels to the left
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        
                      )),
                  SizedBox(
                    height: hlen * 0.045,
                    width: wlen * 0.62,
                    child: Material(
                    color: Colors.transparent,
                      child: TextField(
                        controller: _dob_controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(150, 42, 65, 82),
                          hintText: 'Date Of Birth',
                          contentPadding: EdgeInsets.only(
                              left: 20, top: 0, bottom: 30, right: 20),
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Manrope',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w100,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: hlen * 0.07),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    login(_regsiter_controller.text, _dob_controller.text);
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    minimumSize: Size(wlen * 0.25, hlen * 0.04),
                    backgroundColor: Color.fromARGB(136, 38, 49, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
  ),

        
        );
  }
}
