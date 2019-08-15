import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool _permission = false;

Location location = Location();
LocationData locationData;

initLocation() async {
  await location.changeSettings(
      accuracy: LocationAccuracy.HIGH, interval: 1000);
  try {
    bool serviceStatus = await location.serviceEnabled();
    print("Service status: $serviceStatus");
    if (serviceStatus) {
      _permission = await location.requestPermission();
      print("Permission: $_permission");
      if (_permission) {
        locationData = await location.getLocation();
        print("${locationData.latitude}  ${locationData.longitude}");
      }
    }
  } on PlatformException catch (e) {
    print(e);
    locationData = null;
  }
}
