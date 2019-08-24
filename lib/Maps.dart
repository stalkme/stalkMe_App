import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;
import 'package:stalkme_app/widgets/BottomMenu.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;
import 'package:stalkme_app/util/userInfo.dart' as userInfo;

class MapsMainScreen extends StatefulWidget {
  @override
  _MapsMainScreenState createState() => _MapsMainScreenState();
}

class _MapsMainScreenState extends State<MapsMainScreen> {
  Completer<GoogleMapController> controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Maps(controller: controller),
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomMenu(controller: controller)),
        ],
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

class _MapsState extends State<Maps> {
  LatLng _center = LatLng(
      locationUtil.locationData.latitude, locationUtil.locationData.longitude);
  final Set<Marker> _markers = Set();
  TextEditingController _username;
  TextEditingController _message;

  @override
  void initState() {
    super.initState();
    updateMapMarkers();
    _username = TextEditingController();
    _message = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _message.dispose();
    super.dispose();
  }

  void updateMapMarkers() {
    //Every 10 seconds update markers set, starting with users marker
    setState(() {
      addUserPin();
    });

    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      setState(() {
        locationUtil.getLocation();
        addUserPin();
        //TODO: Add connection to the server and create pins for each user
      });
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
    _markers.clear();
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
