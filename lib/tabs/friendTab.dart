import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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

  Widget friendTile(BuildContext context, String name) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //TODO: On clicked focus map on friend's location.
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: Container(
                    width: deviceSize.size.width * 0.85,
                    height: deviceSize.size.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(name,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                              )),
                        ),
                        SizedBox(height: 15),
                        Text("His message",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Color(0x99000000),
                                decoration: TextDecoration.none)),
                        SizedBox(height: 15),
                        Flexible(
                            child: GestureDetector(
                          onTap: () {
                            print('locate');

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.5)),
                            ),
                            child: Center(
                              child: Text(
                                'Locate friend',
                                style: TextStyle(
                                  color: Color(0x99000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        )),
                        Flexible(
                            child: GestureDetector(
                          onTap: () {
                            print('delete');

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFF416C),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18)),
                            ),
                            child: Center(
                              child: Text(
                                'Delete friend',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Roboto',
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        },
        child: Container(
          height: 50,
          width: deviceSize.size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform.rotate(
                  angle: math.pi / 4,
                  child: Icon(
                    Icons.navigation,
                    color: Colors.black,
                    size: deviceSize.size.width * 0.077,
                  )),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children:
            filteredFriends.map((item) => friendTile(context, item)).toList());
  }
}
