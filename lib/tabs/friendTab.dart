import 'package:flutter/material.dart';

class FriendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int id) {
        return Text('This is text nr $id in friends');
      },
    );
  }
}
