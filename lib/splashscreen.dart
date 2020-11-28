import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/chatbot.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () =>
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FriendlychatApp()),
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Expanded(
              flex: 3,
              child: Container(
                child: Image.asset(
                  "splash_logo.jpg"),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Image.asset(
                  "assets/images/spinner.gif"),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void ater(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('반가워요!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('봇한테 질문을 해보세요.'),
                Text('Ex) 수강신청 언제까지야?')
              ],
            ),
          ),
          actions: [
            FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
            )
          ],
        );
      }
    );

  }
}