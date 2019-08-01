import 'package:flutter/material.dart';
import 'package:stalkme_app/loginScreen.dart';
import 'package:stalkme_app/maps.dart';

void main() => runApp(MaterialApp(
      title: 'Stalk Me',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/maps': (context) => MapsMainScreen(),
      },
    ));
