import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../config/constants.dart';
import '../../../core/abstract/base_functions.dart';
import '../../../utils/shared_objects.dart';
import '../../local_db/utils/db_manager.dart';
import '../../mqtt/state_provider/mqtt_state.dart';
import '../../mqtt/utils/mqtt_manager.dart';
import '../models/models/chat_message.dart';

class ChatFunction extends BaseChatFunction {
  MQTTManager? _manager;
  String? myUid = SharedObjects.prefs.getString(Constants.sessionUid);
  @override
  void blockUser(BuildContext context, String chatId) {}

  @override
  Future<void> createChatIdForContact(String contactPhoneNumber) {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  @override
  Future<List<ChatMessage>> getAllMsgsFromMessagesTable(String chatId) async {
    // OOZ burada mesajlar Local DB 'den okunur.
    List<ChatMessage> messagesFromDb = await DBManager.db.readAllMessagesfromMessagesTable(chatId);
    return Future.value(messagesFromDb);
  }

  Future<File?> testCompressAndGetFile(File file) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempPath + "/temp.jpg",
      minHeight: 400,
      minWidth: 400,
      quality: 80,
    );
    return result;
  }

  @override
  void sendImageToServer(BuildContext context, File imageFile, String chatId) async {
    _manager ??= context.read<MQTTState>().manager;

    File? newFile = await testCompressAndGetFile(imageFile);

    String base64Image = base64Encode(newFile!.readAsBytesSync());
    String msgToSend = '{"msg" : "$base64Image", "type" : "image", "uid" : "$myUid"}';

    while (!_manager!.isConnectionActive()) {
      await Future.delayed(const Duration(seconds: 1));
    }
    _manager!.publishMessage(msgToSend, chatId);
  }

  @override
  void sendMessageToServer(BuildContext context, String msg, String chatId) {
    _manager ??= context.read<MQTTState>().manager;
    debugPrint("calling send message to server");
    Map msgMap = {"msg": msg, "type": "text", "uid": "$myUid"};
    String msgToSend = json.encode(msgMap);
    _manager!.publishMessage(msgToSend, chatId);
  }

  @override
  void sendServiceMsgToServer(BuildContext context, String msg, String chatId) {
    _manager ??= context.read<MQTTState>().manager;
    DBManager.db.updateBlockStatus(0, chatId);
    _manager!.unSubscribeTopic(chatId);
  }

  @override
  void unBlockUser(BuildContext context, String chatId) {
    _manager ??= context.read<MQTTState>().manager;
    DBManager.db.updateBlockStatus(1, chatId);
    _manager!.subscribeTopic(chatId);
  }
}
