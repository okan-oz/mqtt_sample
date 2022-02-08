import 'package:flutter/material.dart';

import '../../mqtt/utils/mqtt_manager_1.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  final String topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String lastSendMessage = '';
  void sendMessage(String message) {
    mqttClientManager.publishMessage(message, widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.topic}'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    minLines: 15,
                    maxLines: 20,
                    initialValue: '',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '',
                      label: Text('Received Messages'),
                    ),
                    onSaved: (String? value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 1,
                          initialValue: '',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '',
                            label: Text('Send Messages'),
                          ),
                          onSaved: (String? value) {
                            lastSendMessage = value!;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            sendMessage(lastSendMessage);
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
