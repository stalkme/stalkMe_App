import 'package:flutter/material.dart';
import 'dart:async';
import 'package:stalkme_app/util/deviceSize.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/widgets/BottomMenu.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;

class MapsMainScreen extends StatefulWidget {
  @override
  _MapsMainScreenState createState() => _MapsMainScreenState();
}

class _MapsMainScreenState extends State<MapsMainScreen> {
  String username;
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

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController mapController) {
    widget.controller.complete(mapController);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 16.0,
      ),
    );
  }
}
