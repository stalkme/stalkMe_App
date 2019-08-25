import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;
import 'package:stalkme_app/widgets/BottomMenu.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;
import 'package:stalkme_app/util/userInfo.dart' as userInfo;
import 'package:stalkme_app/util/userClass.dart';
import 'package:stalkme_app/util/friendList.dart';

class MapsMainScreen extends StatefulWidget {
  @override
  _MapsMainScreenState createState() => _MapsMainScreenState();
}

class _MapsMainScreenState extends State<MapsMainScreen> {
  Completer<GoogleMapController> controller = Completer();
  PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        maxHeight: deviceSize.size.height * 0.6 + 66,
        minHeight: 66,
        parallaxEnabled: true,
        parallaxOffset: .5,
        color: Colors.transparent,
        boxShadow: null,
        body: Maps(controller: controller),
        panel: BottomMenu(controller: controller, panelController: panelController),
      ),
    );
  }
}

class Maps extends StatefulWidget {
  Maps({Key key, @required this.controller}) : super(key: key);
  final Completer<GoogleMapController> controller;
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with WidgetsBindingObserver{
  LatLng _center = LatLng(
      locationUtil.locationData.latitude, locationUtil.locationData.longitude);
  final Set<Marker> _markers = Set();
  TextEditingController _username;
  TextEditingController _message;
  AppLifecycleState _lifecycleState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
  }

  @override
  void initState() {
    super.initState();
    updateMapMarkers();
    _username = TextEditingController();
    _message = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _username.dispose();
    _message.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateMapMarkers() {
    //Every 10 seconds update markers set, starting with users marker
    setState(() {
      _markers.clear();
      addUserPin();
    });

    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (_lifecycleState.index == 0) {
        setState(() {
          _markers.clear();
          locationUtil.getLocation();
          addUserPin();
          addOthersPin(User(nickname: 'Test', message: 'My message', latitude: 51.403704, longitude: 21.148934));
          //TODO: Add connection to the server and create pins for each user
        });
      }
    });
  }

  Widget userDialogBuilder(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 8),
        width: deviceSize.size.width * 0.85,
        height: deviceSize.size.height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: deviceSize.size.width * 0.7,
              height: deviceSize.size.height * 0.08,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: userInfo.userInfo.nickname,
                    icon: Icon(Icons.account_circle, color: Color(0xFFFF483E)),
                  ),
                  controller: _username,
                ),
              ),
            ),
            Container(
              width: deviceSize.size.width * 0.7,
              height: deviceSize.size.height * 0.08,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: (userInfo.userInfo.message.isEmpty)
                        ? 'Your new message'
                        : userInfo.userInfo.message,
                    icon: Icon(Icons.message, color: Color(0xFFFF483E)),
                  ),
                  controller: _message,
                ),
              ),
            ),
            Flexible(
                child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
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
                Navigator.pop(context);
                if (_username.text.isNotEmpty) {
                  userInfo.userInfo.nickname = _username.text;
                }
                userInfo.userInfo.message = _message.text;
                _username.clear();
                _message.clear();
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
                    'Save',
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
  }

  void addUserPin() {
    _markers.add(Marker(
      markerId: MarkerId('user'),
      position: LatLng(locationUtil.locationData.latitude,
          locationUtil.locationData.longitude),
      infoWindow: InfoWindow(
          title: userInfo.userInfo.nickname,
          snippet: userInfo.userInfo.message,
          onTap: () {
            showDialog(context: context, builder: userDialogBuilder);
          }),
      icon: userInfo.userIcon,
    ));
  }

  void addOthersPin(User user) {
    _markers.add(Marker(
      markerId: MarkerId(user.id.toString()),
      position: LatLng(user.latitude,
          user.longitude),
      infoWindow: InfoWindow(
          title: user.nickname,
          snippet: user.message,
          onTap: () {
            showDialog(context: context, builder: (BuildContext context){
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
                                  'Cancel',
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
                              setState(() {
                                friendList.add(user);
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
                                  'Add to friends',
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
          }),
      icon: userInfo.othersIcon,
    ));
  }

  void _onMapCreated(GoogleMapController mapController) {
    widget.controller.complete(mapController);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      mapToolbarEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16.0,
      ),
      markers: _markers,
    );
  }
}
