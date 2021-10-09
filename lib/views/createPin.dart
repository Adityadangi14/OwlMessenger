import 'package:chatapp/helper/helperfunction.dart';

import 'package:chatapp/views/chatRooms.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CreatePinScreen extends StatelessWidget {
  final String chatRoomId;
  CreatePinScreen(this.chatRoomId);
  final TextEditingController userPinTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: userPinTextEditingController,
              obscureText: true,
              decoration: textFieldInputDecoration("Create PIN"),
              style: simpleTextStyle(),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, bool> userSecretMap = {chatRoomId: true};
                String userSecretMapToJson = json.encode(userSecretMap);

                HelperFunctions.saveUserHasPinStatus(true);
                HelperFunctions.saveUserPin(userPinTextEditingController.text);
                HelperFunctions.saveSecretUserMap(userSecretMapToJson);
                print("all data saved");

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChatRooms();
                    },
                  ),
                );
              },
              child: Text("CREATE"),
            )
          ],
        ),
      ),
    );
  }
}
