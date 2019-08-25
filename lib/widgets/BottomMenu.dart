import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:stalkme_app/tabs/friendTab.dart';
import 'package:stalkme_app/tabs/filterTab.dart';
import 'package:stalkme_app/widgets/navBar.dart';
import 'package:stalkme_app/util/deviceSize.dart';

class BottomMenu extends StatefulWidget {
  BottomMenu(
      {Key key, @required this.controller, @required this.panelController})
      : super(key: key);
  final Completer<GoogleMapController> controller;
  final PanelController panelController;

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.6 + 66,
      child: Column(
        children: <Widget>[
          NavBar(
            tabController: tabController,
            panelController: widget.panelController,
            controller: widget.controller,
          ),
          SizedBox(height: 5),
          ContextMenu(tabController: tabController),
        ],
      ),
    );
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
      child: TabBarView(
        controller: widget.tabController,
        children: <Widget>[
          Container(
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
            child: FriendTab(),
          ),
          Container(
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
            child: FilterTab(),
          ),
        ],
      ),
    );
  }
}
