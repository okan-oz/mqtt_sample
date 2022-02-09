import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../utils/SharedObjects.dart';
import '../../chat/screens/chat_home_screen.dart';
import '../../home/screens/home_screen.dart';
import '../models/session_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 22.0),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          maxLines: 1,
                          initialValue: 'username',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your username',
                            label: Text('username'),
                          ),
                          onSaved: (String? value) {
                            initialSession(username: value!);
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 1.0,
                        ),
                      ),
                      onPressed: () async {
                        _formKey.currentState!.save();
                        await SharedObjects.prefs.setBool('login', false);
                        await SharedObjects.prefs.setString(Constants.sessionUid, currentSession.username);
                        SharedObjects.prefs.setString(Constants.sessionUsername, currentSession.username);

                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
