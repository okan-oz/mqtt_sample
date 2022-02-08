import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/mqtt_setting_model.dart';


MQTTClientManager mqttClientManager = MQTTClientManager();

class MQTTClientManager {
  MQTTClientManager();
  MqttSettingModel? _mqttSettingModel;
  MqttServerClient? _client;

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
    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onUnsubscribed = _onUnsubscribed;
    _client!.onSubscribed = _onSubscribed;
    _client!.onSubscribeFail = _onSubscribeFail;
    _client!.pongCallback = _pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs(_mqttSettingModel!.authenticateUsername, _mqttSettingModel!.authenticatePassword)
        .withWillTopic(_mqttSettingModel!.willTopic)
        .withWillMessage(_mqttSettingModel!.willMessage)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMessage;
    try {
      await _client!.connect();
    } catch (e) {
      debugPrint('Exception: $e');
      _client!.disconnect();
    }

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      debugPrint('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      debugPrint('');
    });

    return _client!;
  }

  void disconnect() {
    _client!.disconnect();
  }

  void subcribeTopic(String topic) {
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
}

// connection succeeded
void _onConnected() {
  debugPrint('Connected');
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
