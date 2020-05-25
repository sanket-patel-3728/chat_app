import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByName(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) => print(e));
  }

  addConversionMessage(String chatRoomId, messageMap) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((onError) => print(onError.toString()));
  }

  getConversionMessage(String chatRoomId) async {
    return await Firestore.instance
        .collection('chatRoom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await Firestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
