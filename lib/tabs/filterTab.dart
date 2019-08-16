import 'package:flutter/material.dart';
import 'package:stalkme_app/util/deviceSize.dart' as deviceSize;

class FilterTab extends StatelessWidget {
  Widget filterTile(String name, AssetImage image) {
    return Column(
      children: <Widget>[
        Container(
          width: deviceSize.size.width * 0.16,
          height: deviceSize.size.width * 0.16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          ),
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: deviceSize.size.width * 0.042,
            fontFamily: "Roboto",
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return filterTile('GRILLING', AssetImage('assets/filterGraphics/grill.jpg'));
  }
}