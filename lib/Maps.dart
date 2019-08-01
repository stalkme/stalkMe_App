import 'package:flutter/material.dart';
import 'dart:async';
import 'package:stalkme_app/util/deviceSize.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/widgets/BottomMenu.dart';

class MapsMainScreen extends StatefulWidget {
  //MapsMainScreen({Key key, @required this.userName}) : super(key: key);
  @override
  _MapsMainScreenState createState() => _MapsMainScreenState();
}

class _MapsMainScreenState extends State<MapsMainScreen> {
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dev only'),
      ),
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

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }
}
