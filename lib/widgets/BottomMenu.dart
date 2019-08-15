import 'package:flutter/material.dart';
import 'dart:async';
import 'package:stalkme_app/tabs/friendTab.dart';
import 'package:stalkme_app/tabs/filterTab.dart';
import 'package:stalkme_app/widgets/navBar.dart';
import 'package:stalkme_app/util/deviceSize.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;

class BottomMenu extends StatefulWidget {
  BottomMenu({Key key, @required this.controller}) : super(key: key);
  final Completer<GoogleMapController> controller;
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with TickerProviderStateMixin {
  TabController tabController;
  AnimationController _animationController;
  Animation<Offset> _offsetAnim;
  Tween<Offset> _offsetTween;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
      vsync: this,
    );

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _offsetTween =
        Tween<Offset>(begin: Offset(0, size.height * 0.6), end: Offset(0, 0));

    _offsetAnim = _offsetTween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hideHeight = size.height * 0.6;

    return Transform.translate(
        offset: _offsetAnim.value,
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            _animationController.value = _animationController.value +
                (-1) * (details.primaryDelta / hideHeight);
          },
          onVerticalDragEnd: (DragEndDetails details) {
            if (_animationController.value < 0.5 &&
                details.primaryVelocity.abs() < 500) {
              _animationController.animateTo(0);
            } else if (_animationController.value < 0.5 &&
                details.primaryVelocity.abs() >= 500) {
              _animationController.animateTo(1);
            } else if (_animationController.value >= 0.5 &&
                details.primaryVelocity.abs() < 500) {
              _animationController.animateTo(1);
            } else if (_animationController.value >= 0.5 &&
                details.primaryVelocity.abs() >= 500) {
              _animationController.animateTo(0);
            }
          },
          child: Container(
            height: size.height * 0.6 + 66,
            child: Column(
              children: <Widget>[
                NavBar(
                  tabController: tabController,
                  animationController: _animationController,
                  controller: widget.controller,
                ),
                SizedBox(height: 5),
                ContextMenu(tabController: tabController),
              ],
            ),
          ),
        ));
  }
}

class ContextMenu extends StatefulWidget {
  ContextMenu({Key key, @required this.tabController}) : super(key: key);
  final TabController tabController;
  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      width: size.width,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
      ),
      child: TabBarView(
        controller: widget.tabController,
        children: <Widget>[
          FriendTab(),
          FilterTab(),
        ],
      ),
    );
  }
}
