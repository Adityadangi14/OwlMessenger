import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersByName(String username) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isEqualTo: username)
        .get();
  }

  checkIfUserExist(String userName) async {
    QuerySnapshot name = await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isEqualTo: userName)
        .get();
    if (userName == name.docs[0]['name']) {
      return true;
    } else {
      return false;
    }
  }

  getUsersByEmail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(UserMap) {
    FirebaseFirestore.instance.collection('Users').add(UserMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print("error in createChatroom ------$e.toString()");
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print('$e');
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
