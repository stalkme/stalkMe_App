import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
//import 'package:permission_handler/permission_handler.dart';

//import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);

void main() => runApp(MyApp());

Location location = new Location();
var latitude, longitude;
const oneSec = const Duration(seconds:5);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class Post {
  final int userId;
  final double xcoord;
  final double ycoord;
  final String body;

  Post({this.userId, this.xcoord, this.ycoord, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['ID'],
      xcoord: json['Xcoordinate'],
      ycoord: json['Ycoordinate'],
      body: json['Text'],
    );
  }
}



class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
//  factory Json_Marker.fromJson()
//  {
//    return Json_Marker(
//      {
//
//      }
//    )
//  }
  //static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _AddUserPointer(latitude, longitude) {
    setState(() {
      LatLng _userPos = LatLng(latitude, longitude);
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_userPos.toString()),
        position: _userPos,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    new Timer.periodic(oneSec, (Timer t) => _makeGetRequest());

    return MaterialApp(
      home: Scaffold(
//        appBar: AppBar(
//          title: Text(''),
//          backgroundColor: Colors.green[700],
//        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(50.089195, 19.946430),
            zoom: 15.0,
          ),
          myLocationEnabled: true,
          markers: _markers,
        ),

//        bottomNavigationBar: BottomNavigationBar(
//            items: <BottomNavigationBarItem>[
//              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Test1')),
//              BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('text2')),
//              BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('text3')),
//            ]
//        ),
      ),
    );
  }
}

Future<void> findLocation() async {
  var pos = await location.getLocation();

  latitude = pos.latitude;
  longitude = pos.longitude;
}

//List<Json_Marker> list;
//Future<Post> fetchPost() async {
//  final response =
//  await http.get('https://jsonplaceholder.typicode.com/posts/1');
//
//  if (response.statusCode == 200) {
//    // If server returns an OK response, parse the JSON
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // If that response was not OK, throw an error.
//    throw Exception('Failed to load post');
//  }
//}


_makeGetRequest() async {
    var res = _localhost();
    if (res != "0") {
      print("Sended!");
      http.Response response = await http.get(_localhost());
      //return Post.fromJson(convert.json.decode(response.body));




      //var data = convert.json.decode(response.body);
      //print("Testpo");
      //var Text_list = data.convert.toString();
      //list = Text_list.map<Json_Marker>((json) => Json_Marker.fromJson(json)).toList();
     // print("List size: ${list.length}");

      //print(ID_list);
//      var langitude_list = data["Xcoordinate"] as List;
//      var longitude_list = data["Ycoordinate"] as List;
//      var text_list = data["Text"] as List;
     // text_list.forEach((element) => print(element));
    }
  }

  String _localhost() {

    findLocation();
    if (latitude != null || longitude != null) {
      return 'http://192.168.137.1:8085/?ID=4&Xcoordinate=${latitude}&Ycoordinate=${longitude}&Text=smigusdyn111gus';
    }
    else
     {
        return "0";
     }
}























//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Node server demo',
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: Scaffold(
//        appBar: AppBar(title: Text('Flutter Client')),
//        body: BodyWidget(),
//      ),
//    );
//  }
//}
//
//class BodyWidget extends StatefulWidget {
//  @override
//  BodyWidgetState createState() {
//    return new BodyWidgetState();
//  }
//}
//
//class BodyWidgetState extends State<BodyWidget> {
//  String serverResponse = 'Server response';
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Padding(
//      padding: const EdgeInsets.all(32.0),
//      child: Align(
//        alignment: Alignment.topCenter,
//        child: SizedBox(
//          width: 200,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              RaisedButton(
//                child: Text('Send request to server'),
//                onPressed: () {
//                  _makeGetRequest();
//                },
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(serverResponse),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  _makeGetRequest() async {
//    var res = _localhost();
//    if (res != "0") {
//      http.Response response = await http.get(_localhost());
//      setState(() {
//        serverResponse = response.body;
//      });
//    }
//  }
//
//  String _localhost() {
//
//    findLocation();
//    if (latitude != null || longitude != null) {
//      return 'http://192.168.137.1:8085/?ID=4&Xcoordinate=${latitude}&Ycoordinate=${longitude}&Text=kkkksl';
//    }
//    else
//      {
//        return "0";
//      }
//  }
//}
//
//Location location = new Location();
//var latitude, longitude,latitude1;
//
//Future<void> findLocation() async {
//  var pos = await location.getLocation();
//
//  latitude = pos.latitude;
//  longitude = pos.longitude;
//}
//
//startTimeout([int miliseconds]) {
//  var ms = const Duration(milliseconds: 1);
//  var duration = ms * miliseconds;
//  return new Timer(duration, () => {});
//}