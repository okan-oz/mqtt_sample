import 'package:flutter/material.dart';
import 'chat_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

  
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatHomeScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//   SendMessage sendMessage = SendMessage();
//   late MQTTManager mqttManager;
//   bool isConnectionOpen = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//           padding: const EdgeInsets.all(1.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: <Widget>[
//                 TextFormField(
//                   keyboardType: TextInputType.text, // Use email input type for emails.
//                   decoration: const InputDecoration(hintText: ',Topic', labelText: 'Topic'),
//                   maxLines: 1,
//                   minLines: 1,
//                   initialValue: 'test/topic1',
//                   onSaved: (String? value) {
//                     sendMessage.topic = value!;
//                   },
//                 ),
//                 TextFormField(
//                   keyboardType: TextInputType.text, // Use email input type for emails.
//                   decoration: const InputDecoration(hintText: ',Received Message ', labelText: 'Received Message'),
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(hintText: 'Send', labelText: 'Enter message'),
//                   onSaved: (String? value) {
//                     sendMessage.data = value!;
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: TextButton(
//                           child: const Text(
//                             'Open Connection',
//                             style: TextStyle(color: Colors.green),
//                           ),
//                           onPressed: () async {
//                             await openConnection();
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         child: IconButton(
//                           iconSize: 40,
//                           icon: Icon(
//                             Icons.send_rounded,
//                             color: Colors.blue.shade500,
//                           ),
//                           onPressed: () {
//                             send();
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           )),
//     );
//   }

//   void send() {
//     _formKey.currentState!.save(); // Save our form now.
//     const pubTopic = 'topic/test_';
//     final builder = MqttClientPayloadBuilder();
//     builder.addString(sendMessage.data!);
//     client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
//   }

//   late MqttServerClient client;
//   Future<void> openConnection() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SettingMqttScreen()),
//     );

//     // client = await connect();

//     // setState(() {
//     //   isConnectionOpen = client.connectionStatus!.state == MqttConnectionState.connected;
//     // });

//     // client.subscribe("topic/test_", MqttQos.atLeastOnce);

//     // const pubTopic = 'topic/test_';
//     // final builder = MqttClientPayloadBuilder();
//     // builder.addString('Hello MQTT');
//     // client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
//   }

//   void subcribe() {
//     bool isConnectionOpenNow = mqttManager.IsActiveConnectionStatus();
//     if (!isConnectionOpenNow) {
//       setState(() {
//         isConnectionOpen = false;
//       });

//       return;
//     }
//     _formKey.currentState!.save();
//     mqttManager.subcribeTopic(sendMessage.topic!);
//   }
// }
