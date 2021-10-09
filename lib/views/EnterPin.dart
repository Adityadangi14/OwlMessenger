import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/views/hiddenChatScreen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class EnterPinScreen extends StatefulWidget {
  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String secretPin;

  TextEditingController pinTextEditingController = new TextEditingController();

  @override
  void initState() {
    getSecretPin();

    super.initState();
  }

  getSecretPin() async {
    String data = await HelperFunctions.getUserPinSharedPrefrences();
    secretPin = data;
  }

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
              controller: pinTextEditingController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: textFieldInputDecoration("Enter PIN"),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                if (secretPin == pinTextEditingController.text) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HiddenChatScreen()));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Wrong PIN "),
                        );
                      });
                }
              },
              child: Text("ENTER"),
            )
          ],
        ),
      ),
    );
  }
}
