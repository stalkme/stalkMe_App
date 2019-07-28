import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'maps.dart';
import 'TestingUnit.dart';

void main() => runApp(MaterialApp(
  title: 'Stalk Me',
  initialRoute: '/',
  routes: {
    '/': (context) => LoginScreen(),
    '/maps': (context) => MapsMainScreen(),
    '/tests': (context) => TestingUnit(),
  },
));
