import 'package:chatapp/helper/helperfunction.dart';
import 'package:flutter/material.dart';

class testView extends StatefulWidget {
  @override
  _testViewState createState() => _testViewState();
}

class _testViewState extends State<testView> {
  @override
  String _myName = "notnull";

  Future<String> getName() async {
    return await HelperFunctions.getUserNameSharedPrefrences();
  }

  @override
  void initState() {
    getName();
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    _myName;
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
            future: getName(),
            builder: (BuildContext context, AsyncSnapshot snapshort) {
              if (snapshort.connectionState == ConnectionState.done) {
                return Container(
                  child: Center(
                    child: Text(snapshort.data),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              }
            }));
  }
}
