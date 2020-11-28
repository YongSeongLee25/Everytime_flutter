import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/weather.dart';

enum DataKind { NONE, ADD}
final gServerIp = 'http://54.158.246.73:5000/';

DataKind mKind = DataKind.NONE;

String mResult = '잠시만 기다려주세요. 서버에 연결이 안됐어요!';
String mLeftText;

_launchURL(url) async{
  if (await canLaunch(url)){
    await launch(url);
  }else{
    throw 'Could not launch $url';
  }
}

Future<String> postReply() async {
  if(mLeftText == null)
    return '';

  var addr = gServerIp + ((mKind == DataKind.ADD) ? 'add' : 'multiply');
  var response = await http.post(addr, body: {'left': mLeftText});

  if (response.statusCode == 200)
    return response.body;

  throw Exception('데이터 수신 실패!');
}

const String _name = "나";
const String _named = "KNU ChatBot";

// IOS용 ㄹ테마
final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);


final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,

  accentColor: Colors.orangeAccent[400],
);
final List<ChatMessage> _message = <ChatMessage>[];

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '강남대학교',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
    );
  }
}


class ChatScreen extends StatefulWidget {
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {



  final TextEditingController _textController = TextEditingController();


  bool _isComposing = false;
  bool tp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KNU ChatBot'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 10.0 : 10.0,

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(

              accountName: Text('문의', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('rkwnl1@naver.com', style: TextStyle(fontWeight: FontWeight.bold),),
              onDetailsPressed: (){
              },
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/aaa.jpg'),
                  fit: BoxFit.cover
                ),
                color: Colors.red[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0)
                )
              ),
            ),
            ListTile(
              title: Text('강남대 홈페이지', style: TextStyle(fontSize: 15),),
              onTap: (){
                RaisedButton(onPressed: _launchURL('https://web.kangnam.ac.kr/index.do?send=forward'));
              },
              trailing: Icon(Icons.add),
            ),
            Divider(),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[


            Flexible(

              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),

                reverse: true,
                itemCount: _message.length,
                itemBuilder: (_, index) => _message[index],
              ),
            ),

            Divider(height: 1.0),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),


          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
      ),

    );
  }
  void good(){
    ChatMessage message = ChatMessage(
      text: '안녕',
      type: false,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _message.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // 텍스트 입력 필드
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },

                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration:
                InputDecoration.collapsed(hintText: "챗봇이랑 대화해보세요!"),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],

        ),
      ),
    );
  }




  // 메시지 전송 버튼이 클릭될 때 호출
  void _handleSubmitted(String text) {

    _textController.clear();

    setState(() {
      _isComposing = false;
    });

    mLeftText = text;

    if(mLeftText != null ) {
      mKind = DataKind.ADD;

      try {
        postReply()
            .then((recvd) => mResult = recvd)
            .whenComplete(() {
          if(mResult.isEmpty == false)
            setState(() {});
        });
      } catch (e, s) {
        print(s);
      }
    }

    ChatMessage message = ChatMessage(
      text: text,
      type: false,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    // 리스트에 메시지 추가

    setState(() {
      _message.insert(0, message);
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      Question(mLeftText);
    });

    message.animationController.forward();
  }




  void Question(String text) {

    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: mResult,
      type: true,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );


    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, message);
    });
    // 위젯의 애니메이션 효과 발생
    message.animationController.forward();
  }





  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}


// 리스브뷰에 추가될 메시지 위젯
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과
  final bool type;

  ChatMessage({this.text, this.animationController, this.type});

  List<Widget> otherMessage(context) {
    return <Widget>[

      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(_name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
              decoration: BoxDecoration(
                color : Colors.yellow[400],
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(width: 10, color :Colors.yellow[400])
              ),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(
          '나',
          style: new TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[

      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
            child: new Text(
              'KNU',
              style: new TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(_named, style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
              decoration: BoxDecoration(
                  color : Colors.grey[200],
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(width: 10, color :Colors.grey[200])
              ),
            ),
          ],
        ),
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
      child : Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    ),
    );
  }
}