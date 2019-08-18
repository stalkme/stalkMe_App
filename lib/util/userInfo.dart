import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String username = "Player";
String msg = "Test message";
String filterName = "Default";
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