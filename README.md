# mqtt_sample
<p>This project is sample for  <a href="https://mqtt.org/"><B>MQTT</B></a> with flutter.</p>
<p>The <a href="https://pub.dev/packages/mqtt_client">MQTT client</a> has been used successfully with the MQTT broker(broker.emqx.io)</p>
<p>You can change default settings on <a href="https://github.com/okan-oz/mqtt_sample/blob/master/flutter_mqtt_chat_sample/lib/module/mqtt/models/mqtt_setting_model.dart">mqtt_setting_model.dart</a>  file and  change another broker.</p>
<p>Also you see the <B>Flutter Bloc</B> sample using for Chat Screen on this project and you can see the using of <B>sqflite</B></p>
<p>Firstly login with your credential .These informations are used for connection the MQTT server.If you want to use one more </p>

<p>HomeBloc(ConnectToServerEvent) is responsible for the open the connection with MQTT.</p>
<p>If you want to use it on more than one device at the same time, you should write different phone numbers. Any verification etc. won't want to.</p>
<img width="379" alt="Screenshot 2022-02-13 at 15 23 32" src="https://user-images.githubusercontent.com/62757704/153769769-9f60ba42-cb4e-4a78-b79e-ecd396f98109.png">
<p>If you want to use it on more than one device at the same time, you should write different phone numbers. Any verification etc. won't be wanted.</p>

<img width="366" alt="Screenshot 2022-02-13 at 15 24 37" src="https://user-images.githubusercontent.com/62757704/153770558-1d09abcf-775e-417e-a381-725bf517c146.png">

![Screenshot 2022-02-13 at 22 06 33](https://user-images.githubusercontent.com/62757704/153770678-d17922cc-73a0-4dae-a5c9-d3fa5d65aca7.png)

<p>You can subscribe to the topic you want on this screen.</p>

![Screenshot 2022-02-13 at 21 42 22](https://user-images.githubusercontent.com/62757704/153770799-ccb8740a-9e0c-495b-97ba-8f6c054c5d06.png)

You can review this file for details of mqtt operations.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../chat/blocs/chat_bloc.dart';
import '../../home/blocs/home_bloc.dart';
import '../models/mqtt_setting_model.dart';
import 'mqtt_manager_helper.dart';


class MQTTManager {
  MQTTManager({this.context});
  MqttSettingModel? _mqttSettingModel;
  MqttServerClient? _client;
  BuildContext? context;

  late ChatBloc chatBloc;
  late HomeBloc homeBloc;

  Future<bool> connect() async {
    await _connect();

    return isConnectionActive();
  }

  void initialize(MqttSettingModel settingModel) {
    _mqttSettingModel = settingModel;
  }

  bool isConnectionActive() {
    if (_client != null && _client!.connectionStatus!.state == MqttConnectionState.connected) {
      return true;
    } else {
      return false;
    }
  }

  Future<MqttServerClient> _connect() async {
    if (_mqttSettingModel == null) {
      throw Exception('You must initialize with initialize method!');
    }

    _client = MqttServerClient.withPort(_mqttSettingModel!.serverUrl, _mqttSettingModel!.clientIdentifier, _mqttSettingModel!.port);
    _client!.logging(on: true);
    _setClientCallBack();
    _client!.connectionMessage = _getMqttConnectMessage();

    try {
      //await _client!.connect();
      await _client!.connect(_mqttSettingModel!.clientIdentifier, _mqttSettingModel!.userPassword);
    } catch (e) {
      debugPrint('Exception: $e');
      _client!.disconnect();
    }

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      MqttManagerHelper.receivedMessageListen(c, chatBloc, homeBloc);
    });

    return _client!;
  }

  void _setClientCallBack() {
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onUnsubscribed = _onUnsubscribed;
    _client!.onSubscribed = _onSubscribed;
    _client!.onSubscribeFail = _onSubscribeFail;
    _client!.pongCallback = _pong;
  }

  MqttConnectMessage _getMqttConnectMessage() {
    final connMessage = MqttConnectMessage()
        .authenticateAs(_mqttSettingModel!.authenticateUsername, _mqttSettingModel!.authenticatePassword)
        .withWillTopic(_mqttSettingModel!.willTopic)
        .withWillMessage(_mqttSettingModel!.willMessage)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    return connMessage;
  }

  void disconnect() {
    _client!.disconnect();
  }

  void subscribeTopic(String topic) {
    if (_client == null) {
      throw Exception('You must initialize with initialize method then call the connect');
    }
    _client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publishMessage(String message, String topic) {
    if (_client == null) {
      throw Exception('You must initialize with initialize method then call the connect');
    }
    String pubTopic = topic;
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  void unSubscribeTopic(String topic) {
    _client!.unsubscribe(topic);
  }

// connection succeeded
  void _onConnected() {
    debugPrint('Connected');
    chatBloc = BlocProvider.of<ChatBloc>(context!);
    homeBloc = BlocProvider.of<HomeBloc>(context!);
  }

// unconnected
  void _onDisconnected() {
    debugPrint('Disconnected');
  }

// subscribe to topic succeeded
  void _onSubscribed(String topic) {
    debugPrint('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void _onSubscribeFail(String topic) {
    debugPrint('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void _onUnsubscribed(String? topic) {
    debugPrint('Unsubscribed topic: $topic');
  }

// PING response received
  void _pong() {
    debugPrint('Ping response client callback invoked');
  }
}

