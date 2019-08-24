import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stalkme_app/util/userClass.dart';

User userInfo = User(nickname: 'Player', message: '', activity: 'Default');
String nickname = "Player";
String message = "";
String activity = "Default";
BitmapDescriptor userIcon;
BitmapDescriptor othersIcon;

void loadPinIcons() {
  BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)), 'assets/mapsPins/user.png')
      .then((onValue) {
    userIcon = onValue;
  });
  BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)), 'assets/mapsPins/others.png')
      .then((onValue) {
    othersIcon = onValue;
  });
}