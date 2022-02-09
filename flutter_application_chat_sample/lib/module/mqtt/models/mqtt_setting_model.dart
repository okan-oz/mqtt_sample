import 'package:flutter/gestures.dart';

class MqttSettingModel {
  MqttSettingModel({
    this.autoReconnect = true,
    this.clientIdentifier = 'your identifier',
    this.keepAlivePeriod = 43200,
    this.logging = true,
    this.maxConnectionAttempt = 3,
    this.pongCount = 3,
    this.port = 1883,
    this.serverUrl = 'test.mosquitto.org',
    this.authenticateUsername = 'username',
    this.authenticatePassword = 'password',
    this.willTopic = 'willtopic',
    this.willMessage = 'Will message',
    this.userPassword='',
  });

  String serverUrl = 'test.mosquitto.org';
  String clientIdentifier = 'your identifier';
  bool logging = true;
  int maxConnectionAttempt = 3;
  int pongCount = 0;
  int port = 1883;
  int keepAlivePeriod = 43200;
  bool autoReconnect = true;
  String authenticateUsername = 'username';
  String authenticatePassword = 'password';
  String willTopic = 'willtopic';
  String willMessage = 'Will message';
  String userPassword = '';

  factory MqttSettingModel.setDefault({required String username, required String userPassword}) {
    return MqttSettingModel(
      authenticatePassword: 'password',
      authenticateUsername: 'username',
      clientIdentifier: username,
      keepAlivePeriod: 43200,
      logging: true,
      autoReconnect: true,
      maxConnectionAttempt: 3,
      port: 1883,
      serverUrl: 'broker.emqx.io',
      willMessage: 'Will message',
      pongCount: 3,
      willTopic: 'willtopic',
      userPassword:userPassword,
    );
  }
}
