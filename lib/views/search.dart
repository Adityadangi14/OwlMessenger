import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatRooms.dart';
import 'package:chatapp/views/conversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String _myName;
String chatRoomId;

class _SearchState extends State<Search> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future getName() async {
    Constants.MyName =
        _myName = await HelperFunctions.getUserNameSharedPrefrences();
  }

  QuerySnapshot searchSnapshort;
  initiateSearch() {
    getName();
    databaseMethods
        .getUsersByName(searchTextEditingController.text)
        .then((val) {
      print('$val');
      setState(() {
        searchSnapshort = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshort != null
        ? ListView.builder(
            itemCount: searchSnapshort.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshort.docs[index]['name'],
                userEmail: searchSnapshort.docs[index]['email'],
              );
            })
        : Container();
  }

  createChatRoomAndStartConversation({BuildContext context, String userName}) {
    print('function starts here');
    if (userName != Constants.MyName) {
      print(Constants.MyName);

      chatRoomId = getChatRoomId(userName, _myName);

      print('$chatRoomId');

      List<String> users = [userName, _myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      print('$chatRoomMap');
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      print('done --------------------');

      FutureBuilder(
          future: myNavigator(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ConversationScreen(chatRoomId);
            }
          });
      print("navigator finished---------");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              Text(userEmail, style: mediumTextStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              print('function starts here 2');
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.blue),
              child: Text(
                'Meassage',
                style: mediumTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    print("print here $a $b");
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: ' Search Username!...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        padding: EdgeInsets.all(9),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0x36FFFFFF), Color(0xFFFFFFFF)],
                            ),
                            borderRadius: BorderRadius.circular(40)),
                        child: Image.asset('assets/images/search_white.png')),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

  Future<Widget> myNavigator() async {
    return await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return ConversationScreen(chatRoomId);
    }));
  }
}
