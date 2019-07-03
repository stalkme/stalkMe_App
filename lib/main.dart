import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'Maps.dart';

void main() => runApp(MaterialApp(
  title: 'Stalk Me',
  initialRoute: '/',
  routes: {
    '/': (context) => LoginScreen(),
    '/maps': (context) => MapsMainScreen(),
  },
));
