import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;

class FriendTab extends StatefulWidget {
  @override
  _FriendTabState createState() => _FriendTabState();
}

class _FriendTabState extends State<FriendTab> {
  List<String> friends = List();
  List<String> filteredFriends = List();
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) {
      friends.add('Friend $i');
    }
    filteredFriends.addAll(friends);

    textEditingController = TextEditingController()
      ..addListener(() {
        if (textEditingController.text.isEmpty) {
          setState(() {
            filteredFriends.clear();
            filteredFriends.addAll(friends);
          });
        } else {
          setState(() {
            filteredFriends.clear();
            for (int i = 0; i < friends.length; i++) {
              if (friends[i]
                  .toLowerCase()
                  .contains(textEditingController.text.toLowerCase())) {
                filteredFriends.add(friends[i]);
              }
            }
          });
        }
      });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SearchBar(textEditingController: textEditingController),
        SizedBox(height: 20),
        FriendList(filteredFriends: filteredFriends),
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  SearchBar({Key key, @required this.textEditingController}) : super(key: key);
  final TextEditingController textEditingController;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: deviceSize.size.width * 0.85,
        height: 35,
        decoration: BoxDecoration(
            color: Color(0xffe0e0e0),
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              )
            ]),
        child: TextField(
          controller: widget.textEditingController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: 'Find a friend',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 7),
            
          ),
        ),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  FriendList({Key key, @required this.filteredFriends}) : super(key: key);
  final List filteredFriends;

  Widget friendTile(String name) {
    return Container(
      height: 50,
      width: deviceSize.size.width * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
              angle: math.pi / 4,
              child: Icon(Icons.navigation, color: Color(0xff654ea3), size: deviceSize.size.width * 0.077,)),
          SizedBox(width: 15),
          Text(
              name,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: deviceSize.size.width * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: filteredFriends.map((item) => friendTile(item)).toList()
    );
  }
}
