// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double hlen =  MediaQuery.of(context).size.height;
    double wlen =  MediaQuery.of(context).size.width;
    // TODO: implement build
    return Container(
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
                child: Image.asset('images/logo.png'),),
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
                            offset: Offset(-20, 0), // Moves the widget 10 pixels to the left
                            child: Image.asset('images/cap.png'),
                          ),
              
                        SizedBox(
                          height: hlen * 0.045,
                          width: wlen * 0.62,
                          child: Material( child: TextField(
                          
                          decoration: InputDecoration(
                          
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: BorderSide.none,
                              

                            ), 
                            filled: true,
                              fillColor: Color.fromARGB(150,42, 65, 82),
                            hintText: 'Register Number',
                            contentPadding: EdgeInsets.only(left: 20, top: 0, bottom: 30, right: 20),
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
                            offset: Offset(-20, 0), // Moves the widget 10 pixels to the left
                            child: Icon(Icons.lock, color: Colors.white, size: 30,)
                          ),
              
                        SizedBox(
                          height: hlen * 0.045,
                          width: wlen * 0.62,
                          child: Material( child: TextField(
                          
                          decoration: InputDecoration(
                          
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              borderSide: BorderSide.none,
                              

                            ), 
                            filled: true,
                              fillColor: Color.fromARGB(150,42, 65, 82),
                            hintText: 'Date Of Birth',
                            contentPadding: EdgeInsets.only(left: 20, top: 0, bottom: 30, right: 20),
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
                child: ElevatedButton(onPressed: (){
                
                }, child: Text('Login'), style: ElevatedButton.styleFrom(
                  elevation: 10,
                  minimumSize: Size(wlen * 0.25, hlen * 0.04),
                  primary: Color.fromARGB(136, 38, 49, 70),
                  
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(18.0),
                    
                  ),
                ),
                ),
              ),
                 
              ],
            
        
      ),
    )
    );
  }
}
