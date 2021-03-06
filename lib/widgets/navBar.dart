import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;

class NavBar extends StatefulWidget {
  NavBar(
      {Key key, this.tabController, this.panelController, this.controller})
      : super(key: key);
  final TabController tabController;
  final PanelController panelController;
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
    _leftIconAnimation =
        ColorTween(begin: Colors.white, end: Color(0xffd8d8d8))
            .animate(widget.tabController.animation);
    _rightIconAnimation = ColorTween(begin: Color(0xffd8d8d8), end: Colors.white)
        .animate(widget.tabController.animation);
  }

  Future<void> centerMapPosition() async {
    GoogleMapController mapController = await widget.controller.future;
    locationUtil.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locationUtil.locationData.latitude, locationUtil.locationData.longitude),
        zoom: 16.0)));
  }

  @override
  Widget build(BuildContext context) {
    String _anim = "idle";
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
                          color: (widget.panelController.isPanelOpen())
                              ? _leftIconAnimation.value
                              : Colors.white,
                          size: 35),
                      onPressed: () {
                        widget.tabController.animateTo(0);
                        if (widget.panelController.isPanelClosed())
                          widget.panelController.open();
                      },
                      padding: EdgeInsets.only(bottom: 2, left: 20),
                    );
                  }),
              AnimatedBuilder(
                  animation: widget.tabController.animation,
                  builder: (BuildContext context, Widget child) {
                    return IconButton(
                      icon: Icon(Icons.filter_list,
                          color: (widget.panelController.isPanelOpen())
                              ? _rightIconAnimation.value
                              : Colors.white,
                          size: 34),
                      onPressed: () {
                        widget.tabController.animateTo(1);
                        if (widget.panelController.isPanelClosed())
                          widget.panelController.open();
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
              onPressed: () {
                centerMapPosition();
                if (widget.panelController.isPanelOpen())
                  widget.panelController.close();
              },
              icon: Icon(Icons.gps_fixed, color: Colors.white, size: 35)),
//          child: GestureDetector(
//            onTap: (){
//              setState(() {
//                _anim = 'click';
//              });
//              _anim = 'idle';
//            },
//            child: FlareActor(
//              'assets/flare/locate.flr',
//              animation: 'click',
//            ),
//          )
        )
      ],
    );
  }
}
