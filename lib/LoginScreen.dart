import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'package:stalkme_app/util/deviceSize.dart';
import 'package:stalkme_app/util/locationUtil.dart' as locationUtil;
import 'package:stalkme_app/util/userInfo.dart' as userInfo;

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    userInfo.loadPinIcons();
    locationUtil.getLocation();
    //TODO: Prevent from going further if there is no GPS permission.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF654EA3), const Color(0xFFEAAFC8)])),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text('STALK.ME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              'Stalk strangers, for free!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
            LoginForm(),
          ],
        ),
      ),
    ));
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              width: size.width * 0.80,
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: size.height * 0.25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x26000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    )
                  ]),
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  icon: Icon(Icons.account_circle, color: Color(0xFFFF483E)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 57,
              height: 48,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFFFF416C),
                        const Color(0xFFFF4B2B)
                      ]),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x26000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    )
                  ]),
              child: IconButton(
                padding: EdgeInsets.only(bottom: 0),
                icon: Icon(Icons.arrow_forward, color: Colors.white, size: 45),
                onPressed: () {
                  if (myController.text.isNotEmpty) {
                    userInfo.userInfo.nickname = myController.text;
                  }
                  Navigator.pushNamed(context, '/maps');
                },
              ),
            )
          ],
        ));
  }
}
