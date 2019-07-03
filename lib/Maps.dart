import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userName = ModalRoute.of(context).settings.arguments;
    print(userName);
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

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      value: 20,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          child: child,
          alignment: Alignment(0, _controller.value),
        );
      },
      child: Nav(),
    );
  }
}

class Nav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 200,
            height: 43,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)]),
                borderRadius: BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x26000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.supervisor_account,
                      color: Colors.white, size: 35),
                  onPressed: () {},
                  padding: EdgeInsets.only(bottom: 2, left: 20),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white, size: 34),
                  onPressed: () {},
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
                  colors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)]),
            ),
            child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.gps_fixed, color: Colors.white, size: 35)),
          )
        ],
      ),
    );
  }
}