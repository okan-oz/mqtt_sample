import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/module/chat/models/models/chat_message.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../config/Constants.dart';
import '../../../utils/SharedObjects.dart';
import '../state_provider/mqtt_state.dart';
import 'abstract/base_functions.dart';
import 'mqtt_manager.dart';

class ChatFunction extends BaseChatFunction {
  MQTTManager? _manager;
  String? myUid = SharedObjects.prefs.getString(Constants.sessionUid);
  @override
  void blockUser(BuildContext context, String chatId) {
    // TODO: implement blockUser
  }

  @override
  Future<void> createChatIdForContact(String contactPhoneNumber) {
    // TODO: implement createChatIdForContact
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<List<ChatMessage>> getAllMsgsFromMessagesTable(String chatId) {
    // TODO: implement getAllMsgsFromMessagesTable

    return Future.value(<ChatMessage>[]);
  }

  @override
  void sendImageToServer(BuildContext context, File imageFile, String chatId) {
    // TODO: implement sendImageToServer
  }

  @override
  void sendMessageToServer(BuildContext context, String msg, String chatId) {
    if (_manager == null) {
      _manager = context.read<MQTTState>().manager;
    }
    print("calling send message to server");
    Map msgMap = {"msg": "$msg", "type": "text", "uid": "$myUid"};
    String msgToSend = json.encode(msgMap);
    _manager!.publishMessage(msgToSend, chatId);
  }

  @override
  void sendServiceMsgToServer(BuildContext context, String msg, String chatId) {
    // TODO: implement sendServiceMsgToServer
  }

  @override
  void unBlockUser(BuildContext context, String chatId) {
    // TODO: implement unBlockUser
  }
}
