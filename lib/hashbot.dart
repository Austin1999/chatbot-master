// import 'dart:html';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                // onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {
                  _handleSubmitted(_textController.text);
                },
                // onPressed: () => _handleSubmitted(_textController.text)
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Austin",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    response(text);
  }

  void response(message) async {
    var url = Uri.parse('https://looptune.com/api/hashbot.php');
    var body = {"req": request, "query": message};
    var response = await http.post(
      url,
      body: json.encode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var data = json.decode(response.body);
    ChatMessage msg = new ChatMessage(
      text: data["response"],
      name: "Bot",
      type: false,
    );
    setState(() {
      _messages.insert(0, msg);
      request = data['for'];
    });
  }

  var request = "normal";
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getRobotResponse("My Account balance");
  // }

  final messageInsert = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Hashbot",
          ),
        ),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  // void getRobotResponse(String message) async {
  //   var url = Uri.parse('https://looptune.com/api/hashbot.php');
  //   var body = {"req": request, "query": message};
  //   var response = await http.post(
  //     url,
  //     body: json.encode(body),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //   var data = json.decode(response.body);
  //   print(data["for"]);
  //   print(data["response"]);
  //   // var msg = data["response"];
  //   ChatMessage messa = new ChatMessage(
  //     text: _textController.text,
  //     name: "Austin",
  //     type: true,
  //   );
  //   setState(() {
  //     _messages.insert(0, messa);
  //   });
  //   _textController.clear();
  //   ChatMessage msg = new ChatMessage(
  //     text: data["response"],
  //     name: "Bot",
  //     type: false,
  //   );
  //   setState(() {
  //     _messages.insert(0, msg);
  //   });
  // }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child:
            new CircleAvatar(child: new Image.asset("assets/images/robot.png")),
      ),
      new Expanded(
        child: Bubble(
          nip: BubbleNip.leftTop,
          alignment: Alignment.topLeft,
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(this.name,
                  style: new TextStyle(fontWeight: FontWeight.bold)),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: Bubble(
          alignment: Alignment.topRight,
          nip: BubbleNip.rightTop,
          color: Colors.blue[50],
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(this.name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
