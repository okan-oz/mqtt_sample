import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/module/auth/screens/login_screen.dart';
import 'package:flutter_application_chat_sample/module/chat/screens/chat_home_screen.dart';
import 'package:flutter_application_chat_sample/utils/SharedObjects.dart';

import 'module/home/screens/home_screen.dart';
import 'module/mqtt/utils/mqtt_function.dart';
// import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool newUser = false;
  //UserDataFunction userDataFunction;
  late MQTTFunction mqttFunction;
  //String loggedInUser;

  void checkIfAlreadyLogin(BuildContext context) async {
    newUser = (SharedObjects.prefs.getBool('login') ?? true);
    debugPrint(newUser.toString());
    if (newUser == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => checkIfAlreadyLogin(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              width: 140.0,
              height: 140.0,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(2.5, 3.5), //(x,y)
                    blurRadius: 2.5,
                  ),
                ],
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
              ),
              child: const Center(
                  child: Icon(
                Icons.favorite,
                size: 80.0,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
