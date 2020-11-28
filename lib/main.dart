import 'package:flutter_app/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/splashscreen.dart';

void main() => runApp(flutterapp());

class flutterapp extends StatefulWidget {
  @override
  _flutterappState createState() => _flutterappState();
}

class _flutterappState extends State<flutterapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '강남대학교',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
//        fontFamily: "Schyler",
          textTheme: TextTheme(
            bodyText1: TextStyle(color: kTextColor),
            bodyText2: TextStyle(color: kTextColor),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen()
//      initialRoute: OnboardingScreen.routeName,
//      routes: routes,
    );
  }
}