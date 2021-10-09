import 'dart:ui';

import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController messageController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Container(
            padding: EdgeInsets.only(bottom: 100),
            child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index].data()['message'],
                      snapshot.data.docs[index].data()['sendby'] ==
                          Constants.MyName);
                }),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void sendMessage() {
    print('inside sendMessage----------');
    if (messageController.text.isNotEmpty) {
      print('inside if-------');
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendby": Constants.MyName,
        "time": DateTime.now().microsecondsSinceEpoch
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
        print(chatMessageStream);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Positioned(
              bottom: 0,
              child: Container(
                color: Color(0x54ffffff),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: ' Message!...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            padding: EdgeInsets.all(9),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0xFFFFFFFF)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40)),
                            child: Image.asset('assets/images/send.png')),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
              colors: isSendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
