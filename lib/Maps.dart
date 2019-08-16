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
  BitmapDescriptor userIcon;
  BitmapDescriptor othersIcon;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'assets/mapsPins/user.png')
        .then((onValue) {
      userIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/mapsPins/others.png')
        .then((onValue) {
      othersIcon = onValue;
    });
    updateMapMarkers();
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

  void addUserPin() {
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId('user'),
      position: LatLng(locationUtil.locationData.latitude,
          locationUtil.locationData.longitude),
      infoWindow: InfoWindow(
        title: userInfo.username,
        snippet: userInfo.msg,
      ),
      icon: userIcon,
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
