import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mqtt/screens/settings_mqtt_screen.dart';
import '../../mqtt/state_provider/mqtt_state.dart';
import 'chat_screen.dart';
import '../../mqtt/utils/mqtt_manager.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatHomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentSelectedTopic = '';
  bool isConnectionActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Home'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    isConnectionActive == true
                        ? Icon(
                            Icons.connected_tv,
                            color: Colors.green.shade600,
                            size: 40.0,
                          )
                        : Icon(
                            Icons.connected_tv,
                            color: Colors.red.shade600,
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      child: const Text(
                        'Connection Settings',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingMqttScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 1,
                  initialValue: 'test/topic1',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Topic',
                    label: Text('Topic'),
                  ),
                  onSaved: (String? value) {
                    currentSelectedTopic = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        // mqttClientManager.subcribeTopic(currentSelectedTopic);
                        MQTTManager? manager = context.read<MQTTState>().manager;
                        debugPrint("SUBSCRIBING TO TOPIC : $currentSelectedTopic");
                        manager!.subscribeTopic(currentSelectedTopic);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    topic: currentSelectedTopic,
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
