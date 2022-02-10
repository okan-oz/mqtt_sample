import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../../config/constants.dart';
import '../../../utils/shared_objects.dart';
import '../../chat/blocs/chat_bloc.dart';
import '../../chat/blocs/chat_event.dart';
import '../../home/blocs/home_bloc.dart';
import '../../local_db/utils/db_manager.dart';

class MqttManagerHelper {
  static void receivedMessageListen(List<MqttReceivedMessage<MqttMessage?>>? c, ChatBloc chatBloc, HomeBloc homeBloc) {
    _processingData(c, chatBloc, homeBloc);
  }

  static void _processingData(List<MqttReceivedMessage<MqttMessage?>>? c, ChatBloc chatBloc, HomeBloc homeBloc) async {
    final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final String chatId = c[0].topic;
    final Map parsedMsg = json.decode(message);
    final int currTime = DateTime.now().millisecondsSinceEpoch;
    String? myUid = SharedObjects.prefs.getString(Constants.sessionUid);

    debugPrint('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $message -->');

    if (parsedMsg["type"] == "service") {
      // mqtt message if any of my contacts changed his/her profile picture
      if (parsedMsg["msg"] == Constants.profilePicChangeMsg) {
        if (parsedMsg["uid"] != myUid) {
          debugPrint("Profile Pic Changed For $chatId");
          await DBManager.db.updateProfilePicInChatsTable(parsedMsg["profilePicUrl"], chatId);
          homeBloc.add(FetchHomeChatsEvent());
        }
      }
    } else {
// save message to local db
      debugPrint(parsedMsg["uid"]);
      debugPrint(myUid);
      if (parsedMsg["uid"] == myUid) {
        // if uid of message is same as mine then that means
        // I sent the message, so save it to db as sent message
        debugPrint("seetting messages to local db 1");
        await DBManager.db.addNewMessageToMessagesTable(chatId, parsedMsg["msg"], parsedMsg["type"], currTime, 1); // 1 bcox message is sent

      } else {
        debugPrint("seetting messages to local db 0");
        // save the message to local db as received message
        await DBManager.db.addNewMessageToMessagesTable(chatId, parsedMsg["msg"], parsedMsg["type"], currTime, 0); // 0 bcox message is received
      }

      DBManager.db.updateMessageToChatTable(
        chatId,
        parsedMsg["msg"],
        parsedMsg["type"],
        currTime,
      );
 
      chatBloc.add(ReceivedMessageEvent(chatId, message));
      homeBloc.add(FetchHomeChatsEvent());
    }
  }
}
