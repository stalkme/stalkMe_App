import 'package:flutter/material.dart';
import 'package:stalkme_app/util/deviceSize.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;

class NavBar extends StatefulWidget {
  NavBar({Key key, this.tabController, this.animationController, this.controller})
      : super(key: key);
  final TabController tabController;
  final AnimationController animationController;
  final Completer<GoogleMapController> controller;

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Animation<Color> _leftIconAnimation;
  Animation<Color> _rightIconAnimation;

  @override
  void initState() {
    super.initState();
    _rightIconAnimation =
        ColorTween(begin: Colors.white, end: Color(0xffd8d8d8))
            .animate(widget.tabController.animation);
    _leftIconAnimation = ColorTween(begin: Color(0xffd8d8d8), end: Colors.white)
        .animate(widget.tabController.animation);
  }

  Future<void> centerMapPosition() async {
    GoogleMapController mapController = await widget.controller.future;
    locationUtil.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locationUtil.locationData.latitude,
            locationUtil.locationData.longitude), zoom: 16.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              AnimatedBuilder(
                  animation: widget.tabController.animation,
                  builder: (BuildContext context, Widget child) {
                    return IconButton(
                      icon: Icon(Icons.supervisor_account,
                          color: (widget.animationController.value != 0)
                              ? _leftIconAnimation.value
                              : Colors.white,
                          size: 35),
                      onPressed: () {
                        widget.tabController.animateTo(0);
                        if (widget.animationController.value == 0)
                          widget.animationController.animateTo(1);
                      },
                      padding: EdgeInsets.only(bottom: 2, left: 20),
                    );
                  }),
              AnimatedBuilder(
                  animation: widget.tabController.animation,
                  builder: (BuildContext context, Widget child) {
                    return IconButton(
                      icon: Icon(Icons.filter_list,
                          color: (widget.animationController.value != 0)
                              ? _rightIconAnimation.value
                              : Colors.white,
                          size: 34),
                      onPressed: () {
                        widget.tabController.animateTo(1);
                        if (widget.animationController.value == 0)
                          widget.animationController.animateTo(1);
                      },
                      padding: EdgeInsets.only(bottom: 2, right: 20),
                    );
                  }),
            ],
          ),
        ),
        Container(
          width: 64,
          height: 61,
          //margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)]),
          ),
          child: IconButton(
              onPressed: () {centerMapPosition();},
              icon: Icon(Icons.gps_fixed, color: Colors.white, size: 35)),
        )
      ],
    );
  }
}
