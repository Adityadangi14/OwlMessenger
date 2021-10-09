import 'package:chatapp/views/signIn.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/views/signUp.dart';

class authenticate extends StatefulWidget {
  @override
  _authenticateState createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {
  bool showSignIn = true;

  void toggle() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggle);
    } else {
      return SignUp(toggle);
    }
  }
}
