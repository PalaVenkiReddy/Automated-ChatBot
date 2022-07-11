import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    home: Chat(),
  ));
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => ChatBot();
}

class ChatBot extends State<Chat> {
  final TextEditingController _chat = TextEditingController();

  final List<Message> message = <Message>[];

  void getChatBotReply(String userReply) async {
    _chat.clear();
    var response = await http.get(Uri.parse(
        "http://api.brainshop.ai/get?bid=167849&key=TmW0ZfiHA8U2G6vC&uid=${"Venki_Reddy"}&msg=[$userReply]"));
    var data = jsonDecode(response.body);
    var _botReply = data["cnt"];
    Message _message = Message(
      text: _botReply,
      type: false,
    );
    setState(() {
      message.insert(0, _message);
    });
  }

  void startedChatWithBot(text) async {
    _chat.clear();
    Message _message = Message(text: text, type: true);
    setState(() {
      message.insert(0, _message);
    });
    getChatBotReply(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      backgroundColor: Colors.orange[50],
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => message[index],
              itemCount: message.length,
            ),
          ),
          const Divider(height: 2.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: IconTheme(
                data: IconThemeData(color: Theme.of(context).cardColor),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                          //fit: FlexFit.loose,
                          child: TextField(
                        cursorColor: Colors.orange,
                        controller: _chat,
                        onSubmitted: startedChatWithBot,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Have a chat'),
                      )),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconButton(
                          onPressed: () => startedChatWithBot(_chat.text),
                          icon: const Icon(Icons.send),
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final bool type;
  // ignore: use_key_in_widget_constructors
  const Message({
    required this.text,
    required this.type,
  });

  List<Widget> aiBotReply(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: const CircleAvatar(
          child: Text('Bot'),
        ),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20.0),
            ),
          )
        ],
      ))
    ];
  }

  List<Widget> myChat(context) {
    return <Widget>[
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(text, style: const TextStyle(fontSize: 20.0)),
          )
        ],
      )),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: type ? myChat(context) : aiBotReply(context),
      ),
    );
  }
}
