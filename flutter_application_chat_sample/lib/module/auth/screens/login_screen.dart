import 'package:flutter/material.dart';
import '../../../config/constants.dart';
import '../../../utils/SharedObjects.dart';
import '../../home/screens/home_screen.dart';
import '../models/session_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String phoneNumber = '';

  Future<bool> _login() async {
    await SharedObjects.prefs.setBool('login', false);
    await SharedObjects.prefs.setString(Constants.sessionUid, phoneNumber);
    await SharedObjects.prefs.setString(Constants.sessionUsername, username);
    await SharedObjects.prefs.setString(Constants.fullName, username);
    initialSession(username: username, phoneNumber: phoneNumber, fullName: username);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 22.0),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          maxLines: 1,
                          initialValue: 'username',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your username',
                            label: Text('username'),
                          ),
                          onSaved: (String? value) {
                            username = value!;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          maxLines: 1,
                          initialValue: '905555555555',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your phone number',
                            label: Text('Phone Number'),
                          ),
                          onSaved: (String? value) {
                            phoneNumber = value!;
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
                        await _login();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
