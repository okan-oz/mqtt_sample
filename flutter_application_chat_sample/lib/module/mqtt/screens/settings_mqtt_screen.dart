import 'package:flutter/material.dart';
import '../models/mqtt_setting_model.dart';
import '../utils/mqtt_manager.dart';

class SettingMqttScreen extends StatelessWidget {
  SettingMqttScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MqttSettingModel mqttSettings = MqttSettingModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Setting'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  initialValue: 'broker.emqx.io',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a MQTT Server Url',
                    label: Text('MQTT Server Url'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.serverUrl = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: '1883',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a MQTT Server Port',
                    label: Text('MQTT Server Port'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.port = int.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: 'flutter_client',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Client Identifier',
                    label: Text('Client Identifier'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.clientIdentifier = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: 'username',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Authenticate Username',
                    label: Text('Authenticate Username'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.authenticateUsername = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: 'password',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Authenticate password',
                    label: Text('Authenticate password'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.authenticatePassword = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: 'willtopic',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Will topic',
                    label: Text('Will Topic'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.willTopic = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: 'Will message',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Will message',
                    label: Text('Will message'),
                  ),
                  onSaved: (String? value) {
                    mqttSettings.willMessage = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.blue.shade300,
                      child: const Text('Connect'),
                      onPressed: () async {
                        await connect();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      color: Colors.blue.shade300,
                      child: const Text('Disconnect'),
                      onPressed: () async {},
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

  Future<void> connect() async {
    _formKey.currentState!.save();

    // mqttClientManager.initialize(mqttSettings);
    // await mqttClientManager.connect();
  }
}
