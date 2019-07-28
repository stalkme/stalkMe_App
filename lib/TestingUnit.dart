import 'package:flutter/material.dart';
import 'tabs/friendTab.dart';
import 'tabs/filterTab.dart';
import 'widgets/navBar.dart';

class TestingUnit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing unit'),
      ),
      body: BottomMenu(),
    );
  }
}

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6 + 43 + 18,
      color: Colors.black,
      child: Column(
        children: <Widget>[
          NavBar(),
          Contextmenu(),
        ],
      ),
    );
  }
}

class Contextmenu extends StatefulWidget {
  @override
  _ContextmenuState createState() => _ContextmenuState();
}

class _ContextmenuState extends State<Contextmenu> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      width: size.width,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.amber,
      ),
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          FriendTab(),
          FilterTab(),
        ],
      ),
    );
  }
}

