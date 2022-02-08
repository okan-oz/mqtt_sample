// import 'dart:io';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class MQTTManager {
//   String serverUrl = 'test.mosquitto.org';
//   String clientIdentifier = 'OkanOzGuidOrKey';
//   late MqttServerClient _client;
//   bool logging;
//   int maxConnectionAttempt;
//   int pongCount = 0;
//   int port = 1883;
//   int keepAlivePeriod = 43200;
//   bool autoReconnect = true;
//   MQTTManager({
//     required this.clientIdentifier,
//     required this.serverUrl,
//     this.logging = false,
//     this.maxConnectionAttempt = 3,
//     this.port = 1883,
//     this.keepAlivePeriod = 43200,
//     this.autoReconnect = true,
//   });

//   Future<void> initialize() async {
//     _client = MqttServerClient(
//       serverUrl,
//       clientIdentifier,
//       maxConnectionAttempts: maxConnectionAttempt,
//     );
//     _client.logging(on: logging);
//     _client.keepAlivePeriod = keepAlivePeriod;
//     _client.onAutoReconnected = onAutoReconnected;
//     _client.onDisconnected = onDisconnected;
//     _client.onConnected = onConnected;
//     _client.onSubscribed = onSubscribed;
//     _client.pongCallback = onPong;
//   }

//   bool IsActiveConnectionStatus() {
//     if (_client.connectionStatus!.state == MqttConnectionState.connected) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   // void published() {
//   //   _client.published!.listen((MqttPublishMessage message) {
//   //     print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
//   //   });
//   // }

//   void publish(String myMessage, String topic) {
//     final builder = MqttClientPayloadBuilder();
//     builder.addString(myMessage);
//     _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!, retain: true);
//   }

//   void subcribeTopic(String topic) {
//     // print('EXAMPLE::Subscribing to the test/lol topic');
//     // const topic = 'test/lol'; // Not a wildcard topic
//     _client.subscribe(topic, MqttQos.atMostOnce);

//     /// The client has a change notifier object(see the Observable class) which we then listen to to get
//     /// notifications of published updates to each subscribed topic.
//     _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//       final recMess = c![0].payload as MqttPublishMessage;
//       final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//       print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//       print('');
//     });
//   }

//   void unSubscribeTopic(String topic) {
//     _client.unsubscribe(topic);
//   }

//   void disconnect() {
//     _client.disconnect();
//   }

//   MqttConnectMessage _prepareMqttConnectionMessage() {
//     final MqttConnectMessage connMess = MqttConnectMessage()
//         .withClientIdentifier(clientIdentifier)
//         .withWillTopic('willtopic') // If you set this you must set a will message
//         .withWillMessage('My Will message')
//         .startClean() // Non persistent session for testing
//         .withWillQos(MqttQos.atLeastOnce);

//     return connMess;
//   }

//   Future<bool> connect() async {
//     try {
//       _client.connectionMessage = _prepareMqttConnectionMessage();
//       await _client.connect();
//     } on NoConnectionException catch (e) {
//       // Raised by the client when connection fails.
//       print('EXAMPLE::client exception - $e');
//       _client.disconnect();
//     } on SocketException catch (e) {
//       // Raised by the socket layer
//       print('EXAMPLE::socket exception - $e');
//       _client.disconnect();
//     }

//     /// Check we are connected
//     if (_client.connectionStatus!.state == MqttConnectionState.connected) {
//       print('EXAMPLE::Mosquitto client connected');

//       /// The client has a change notifier object(see the Observable class) which we then listen to to get
//       /// notifications of published updates to each subscribed topic.
//       _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//         final recMess = c![0].payload as MqttPublishMessage;
//         final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

//         /// The above may seem a little convoluted for users only interested in the
//         /// payload, some users however may be interested in the received publish message,
//         /// lets not constrain ourselves yet until the package has been in the wild
//         /// for a while.
//         /// The payload is a byte buffer, this will be specific to the topic
//         print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//         print('');
//       });

//       return true;
//     } else {
//       /// Use status here rather than state if you also want the broker return code.
//       print('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client.connectionStatus}');
//       _client.disconnect();
//     }

//     return false;
//   }

//   /// The subscribed callback
//   void onSubscribed(String topic) {
//     print('EXAMPLE::Subscription confirmed for topic $topic');

//     _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//       final recMess = c![0].payload as MqttPublishMessage;
//       final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

//       /// The above may seem a little convoluted for users only interested in the
//       /// payload, some users however may be interested in the received publish message,
//       /// lets not constrain ourselves yet until the package has been in the wild
//       /// for a while.
//       /// The payload is a byte buffer, this will be specific to the topic
//       print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//       print('');
//     });
//   }

//   /// The unsolicited disconnect callback
//   void onDisconnected() {
//     print('EXAMPLE::OnDisconnected client callback - Client disconnection');
//     if (_client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
//       print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
//     } else {
//       print('EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
//       // exit(-1);
//     }
//     if (pongCount == 3) {
//       print('EXAMPLE:: Pong count is correct');
//     } else {
//       print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
//     }
//   }

//   /// The successful connect callback
//   void onConnected() {
//     print('EXAMPLE::OnConnected client callback - Client connection was successful');
//   }

//   /// Pong callback
//   void onPong() {
//     print('EXAMPLE::Ping response client callback invoked');
//     pongCount++;
//   }

//   void onAutoReconnected() {
//     print('EXAMPLE::onAutoReconnected  callback invoked');
//   }
// }
