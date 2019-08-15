import 'package:flutter/material.dart';
import 'dart:async';
import 'package:stalkme_app/util/deviceSize.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/widgets/BottomMenu.dart';
import 'package:location/location.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;

class MapsMainScreen extends StatefulWidget {
  @override
  _MapsMainScreenState createState() => _MapsMainScreenState();
}

class _MapsMainScreenState extends State<MapsMainScreen> {
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Maps(),
          //BottomMenu(),
          Align(alignment: Alignment.bottomCenter, child: BottomMenu()),
        ],
      ),
    );
  }
}

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(locationUtil.locationData.latitude, locationUtil.locationData.longitude);

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
