import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/EnterPin.dart';
import 'package:chatapp/views/chatRooms.dart';
import 'package:chatapp/views/conversationScreen.dart';
import 'package:chatapp/views/createPin.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HiddenChatScreen extends StatefulWidget {
  @override
  _HiddenChatScreenState createState() => _HiddenChatScreenState();
}

class _HiddenChatScreenState extends State<HiddenChatScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Map<String, dynamic> userSecretMap;

  Widget chatRoomList() {
    print(userSecretMap);
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.docs[index].data()["chatroomId"],
                        userSecretMap);
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserSecretMapInfo();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onDoubleTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatRooms()));
            },
            child: Text("OwlMessenger")),
        actions: [
          InkWell(
            onTap: () {
              authMethods.signOut();
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

  ChatRoomTile(this.chatRoomId, this.userSecretMap);

  @override
  Widget build(BuildContext context) {
    if (userSecretMap.containsKey(chatRoomId)) {
      return InkWell(
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

// class ChatRoomAlertDialog extends StatelessWidget {
//   final String chatRoomId;
//   ChatRoomAlertDialog(this.chatRoomId);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Do you want to hide " +
//           chatRoomId.replaceAll("_", "").replaceAll(Constants.MyName, "")),
//       actions: [
//         TextButton(
//           onPressed: () {
//             return Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CreatePinScreen(chatRoomId),
//               ),
//             );
//           },
//           child: Text("Yes"),
//         ),
//       ],
//     );
//   }
// }
