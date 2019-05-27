import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsMainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dev only'),
      ),
      body: Stack(
        children: <Widget>[
          Maps(),
          BottomNavBar(),
        ],
      ),
    );
  }
}


class Maps extends StatefulWidget{
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

class BottomNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
          width: 200,
          height: 43,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFF416C),
                    const Color(0xFFFF4B2B)
                  ]
              ),
              borderRadius: BorderRadius.all(Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ]
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.supervisor_account, color: Colors.white, size: 35),
                  onPressed: (){print('click');},
                  padding: EdgeInsets.only(bottom: 2, left: 20),
                ),
                IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white, size: 34),
                  onPressed: (){},
                  padding: EdgeInsets.only(bottom: 2, right: 20),
                )
              ],
            ),
          ),
          Container(
            width: 64,
            height: 61,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFF416C),
                    const Color(0xFFFF4B2B)
                  ]
              ),
            ),
            child: IconButton(
              onPressed: (){},
                icon: Icon(Icons.gps_fixed, color: Colors.white, size: 35)
            ),
          )
        ],
      ),
      );
  }

}