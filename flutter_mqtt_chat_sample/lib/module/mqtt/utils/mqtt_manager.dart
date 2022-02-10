import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../chat/blocs/chat_bloc.dart';
import '../../home/blocs/home_bloc.dart';
import '../models/mqtt_setting_model.dart';
import 'mqtt_manager_helper.dart';

//MQTTManager mqttClientManager = MQTTManager();

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
