import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stalkme_app/util/userInfo.dart';
import 'package:stalkme_app/util/userClass.dart';

class ServerConnectionHelper {
  http.Client client = http.Client();
  List<User> userList = List();
  ServerConnectionHelper._privateConstructor();

  //Creating singleton class
  static final ServerConnectionHelper instance =
      ServerConnectionHelper._privateConstructor();

  Future<void> connectToServer() async {
    var client = http.Client();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    print(jsonEncode(userInfo));
    try {
      var response = await client.post('http://172.16.0.13:49153',
          headers: headers, body: jsonEncode(userInfo));
      if (response.statusCode == 400) {
        //Error code, TODO: Some logic to handle failure status code
        print('Status code 400');
        return;
      }
      var json = jsonDecode(response.body);
      if (userInfo.id == null) {
        userInfo.id = json['id'];
        connectToServer();
        print("Setting ID to ${userInfo.id}");
      } else {
        //Server sends back all the users in database
        //TODO: Update friends locations
        userList.clear();
        for (var user in json) {
          userList.add(User.fromJson(user));
        }
      }
    } catch (e) {
      print('Unable to connect to server');
    }
  }
}
