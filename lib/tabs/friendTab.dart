import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;
import 'package:stalkme_app/util/userClass.dart';
import 'package:stalkme_app/util/friendList.dart';
import 'package:stalkme_app/util/databaseHelper.dart';

class FriendTab extends StatefulWidget {
  FriendTab({Key key, @required this.googleMapController}) : super(key: key);
  final Completer<GoogleMapController> googleMapController;

  @override
  _FriendTabState createState() => _FriendTabState();
}

class _FriendTabState extends State<FriendTab> {
  List<User> filteredFriendList = List();
  TextEditingController textEditingController;
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController()
      ..addListener(() {
        if (textEditingController.text.isEmpty) {
          setState(() {
            filteredFriendList.clear();
            filteredFriendList.addAll(dbHelper.friendList);
          });
        } else {
          setState(() {
            filteredFriendList.clear();
            for (int i = 0; i < dbHelper.friendList.length; i++) {
              if (dbHelper.friendList[i].nickname
                  .toLowerCase()
                  .contains(textEditingController.text.toLowerCase())) {
                filteredFriendList.add(dbHelper.friendList[i]);
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

  Future<void> _onRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    filteredFriendList.clear();
    filteredFriendList.addAll(dbHelper.friendList);

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          SearchBar(textEditingController: textEditingController),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: <Widget>[
                  FriendList(
                    filteredFriendList: filteredFriendList,
                    googleMapController: widget.googleMapController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFF5F5F5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon(Icons.search,
                  color: Theme.of(context).textTheme.body1.color),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  controller: widget.textEditingController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Find a friend'),
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendList extends StatefulWidget {
  FriendList(
      {Key key,
      @required this.filteredFriendList,
      @required this.googleMapController})
      : super(key: key);
  final List<User> filteredFriendList;
  final Completer<GoogleMapController> googleMapController;

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final dbHelper = DatabaseHelper.instance;

  Future<void> locateFriend(User user) async {
    if (user.longitude != null && user.latitude != null) {
      GoogleMapController _mapController =
          await widget.googleMapController.future;
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(user.latitude, user.longitude), zoom: 16.0)));
    }
  }

  Widget friendTile(BuildContext context, User user) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          locateFriend(user);
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
                          child: Text(user.nickname,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                decoration: TextDecoration.none,
                              )),
                        ),
                        SizedBox(height: 15),
                        Text(user.message,
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
                            locateFriend(user);
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
                            setState(() {
                              dbHelper.removeFriend(user);
                              widget.filteredFriendList.remove(user);
                            });
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
                user.nickname,
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
    return (dbHelper.friendList.isNotEmpty)
        ? Column(
            children: widget.filteredFriendList
                .map((item) => friendTile(context, item))
                .toList())
        : Center(child: Image.asset('assets/vectors/listEmpty.png'));
  }
}
