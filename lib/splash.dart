
import 'package:flutter/material.dart';
import 'package:flutter_app/splashscreen.dart/';

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
        title: '강남대학교에 대한것을 질문해보세요',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
//        fontFamily: "Schyler",
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen()
//      initialRoute: OnboardingScreen.routeName,
//      routes: routes,
    );
  }
}