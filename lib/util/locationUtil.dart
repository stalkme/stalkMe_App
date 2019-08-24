import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stalkme_app/util/userInfo.dart';

bool _permission = false;

Location location = Location();
LocationData locationData;

getLocation() async {
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
        userInfo.latitude = locationData.latitude;
        userInfo.longitude = locationData.longitude;
//        print("${locationData.latitude}  ${locationData.longitude}");
//        location.onLocationChanged().listen((LocationData changedLocation) {
//          locationData = changedLocation;
//        });
      }
    }
  } on PlatformException catch (e) {
    print(e);
    locationData = null;
  }
}
