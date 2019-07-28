import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
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
          //margin: EdgeInsets.only(bottom: 20),
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
    );
  }
}