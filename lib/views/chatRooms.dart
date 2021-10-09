import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/EnterPin.dart';
import 'package:chatapp/views/conversationScreen.dart';
import 'package:chatapp/views/createPin.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Map<String, dynamic> userSecretMap;

  bool userPinStatus;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.docs[index].data()["chatroomId"],
                        userSecretMap,
                        userPinStatus);
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserSecretMapInfo();
    getUserPinStatus();
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.MyName = await HelperFunctions.getUserNameSharedPrefrences();
    databaseMethods.getChatRooms(Constants.MyName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  getUserSecretMapInfo() async {
    String data = await HelperFunctions.getUserSecretMap();
    print("inside getUserSecretMapInfo");
    print(data);
    userSecretMap = json.decode(data);
    print(userSecretMap);
  }

  getUserPinStatus() async {
    bool data = await HelperFunctions.getUserHasPinStatusSharedPrefrences();
    userPinStatus = data;
    print(userPinStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onDoubleTap: () {
              if (userPinStatus) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EnterPinScreen()));
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "You don't  have a pin ! Create a pin to continue. "),
                      );
                    });
              }
            },
            child: Text("OwlMessenger")),
        actions: [
          InkWell(
            onTap: () {
              Map myMap = {};
              String myMapJson = json.encode(myMap);
              authMethods.signOut();
              HelperFunctions.saveSecretUserMap(myMapJson);
              HelperFunctions.saveUserHasPinStatus(false);
              HelperFunctions.saveUserPin("");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Icon(Icons.search),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String chatRoomId;
  final Map userSecretMap;

  final bool userPinStatus;

  ChatRoomTile(this.chatRoomId, this.userSecretMap, this.userPinStatus);

  @override
  Widget build(BuildContext context) {
    if (!userSecretMap.containsKey(chatRoomId)) {
      return InkWell(
        onLongPress: () {
          print("this.chatRoomId, this.userSecretMap, this.userPinStatus");
          print(chatRoomId);
          print(userSecretMap);
          print(userPinStatus);
          showDialog(
              context: context,
              builder: (context) {
                return ChatRoomAlertDialog(
                    chatRoomId, userPinStatus, userSecretMap);
              });
        },
        onTap: () {
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ConversationScreen(chatRoomId);
          }));
        },
        child: Container(
          color: Colors.black45,
          child: Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                    chatRoomId
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.MyName, "")
                        .substring(0, 1)
                        .toLowerCase(),
                    style: TextStyle(fontSize: 25)),
              ),
            ),
            Text(
              chatRoomId
                  .toString()
                  .replaceAll("_", "")
                  .replaceAll(Constants.MyName, ""),
              style: mediumTextStyle(),
            )
          ]),
        ),
      );
    } else {
      return Container();
    }
  }
}

class ChatRoomAlertDialog extends StatefulWidget {
  final String chatRoomId;
  final Map userSecretMap;
  final bool userPinStatus;
  ChatRoomAlertDialog(this.chatRoomId, this.userPinStatus, this.userSecretMap);

  @override
  _ChatRoomAlertDialogState createState() => _ChatRoomAlertDialogState();
}

class _ChatRoomAlertDialogState extends State<ChatRoomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Do you want to hide " +
          widget.chatRoomId
              .replaceAll("_", "")
              .replaceAll(Constants.MyName, "")),
      actions: [
        TextButton(
          onPressed: () {
            if (widget.userPinStatus) {
              widget.userSecretMap.putIfAbsent(widget.chatRoomId, () => true);

              String userSecretMapToJson = json.encode(widget.userSecretMap);
              print(userSecretMapToJson);
              HelperFunctions.saveSecretUserMap(userSecretMapToJson);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ChatRooms()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreatePinScreen(widget.chatRoomId);
              }));
            }
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}
