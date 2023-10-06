import 'dart:async';
import 'package:absen/pages/auth/auth_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SplashPage());
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashPage> {
  double logoOpacity = 0.0; 
  double logoScale = 0.0;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    startLogoAnimation();
  }

  void startLogoAnimation() async {    
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {      
      logoScale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF5591F),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 241, 240, 241),
                Color.fromARGB(255, 87, 178, 235)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              width: logoScale * 300, 
              height: logoScale * 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo1.png'),
                  fit: BoxFit.contain,
                ),
              ),              
            ),
          )
        ],
      ),
    );
  }
}
