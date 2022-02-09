//import 'package:coocoo/managers/mqtt_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/module/mqtt/utils/mqtt_manager.dart';

class MQTTState with ChangeNotifier {
  MQTTManager? _manager;
  final Map<String, String>? _lastSenderMap = {};
  final Map<String, String>? _lastMsgMap = {};

  MQTTManager? get manager => _manager;

  String? getLastSender(String chatId) {
    return _lastSenderMap![chatId];
  }

  String? getLastMsg(String chatId) {
    return _lastMsgMap![chatId];
  }

  void setLastSender(String chatId, String newSender) {
    _lastSenderMap![chatId] = newSender;
  }

  void setLastMsg(String chatId, String newMsg) {
    _lastMsgMap![chatId] = newMsg;
  }

  void setNewManager(MQTTManager newManager) {
    _manager ??= newManager;
    notifyListeners();
  }
}
