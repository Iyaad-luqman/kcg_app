import 'package:flutter/material.dart';
import 'package:kcg_app/dashboard.dart';
import 'package:kcg_app/login.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/splash-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                left: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),  
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 19, 19, 19)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              ),
            ],
          )

        
        ],
      ),
    );
  }
}

