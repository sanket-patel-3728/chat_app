import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversion.dart';
import 'package:chatapp/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot searchSnapShot;
  TextEditingController searchTextController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  initSearch() {
    databaseMethods.getUserByName(searchTextController.text).then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  createChatRoomAndStartConversion({String userName}) async {
    if (userName != Constants.myName) {
      String chatRoomId = await getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversionScreen(chatRoomId),
          ));
    }
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(
                userEmail: searchSnapShot.documents[index].data['email'],
                userName: searchSnapShot.documents[index].data['name'],
              );
            },
          )
        : Container(
            child: Text(
            'No Search Avable ,Try Again',
            style: textStyle(),
          ));
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                child: Text(
                  userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.tealAccent),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                userEmail,
                style: TextStyle(fontSize: 14, color: Colors.tealAccent),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              createChatRoomAndStartConversion(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.pink, Colors.orangeAccent]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 12.0),
                child: Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Search User'),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.blueAccent[200]])),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: TextField(
                        controller: searchTextController,
                        style: TextStyle(
                          fontSize: 23.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: () {
                          initSearch();
                        },
                        child: CircleAvatar(
                          radius: 24.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.search,
                            size: 35.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: searchList(),
            ),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
