class ChatMessage {
  final String msg;
  final int time;
  final String msgType;
  final String chatId;
  final bool isSelf;

  ChatMessage({
    required this.msg,
    required this.time,
    required this.msgType,
    required this.chatId,
    required this.isSelf,
  });

  factory ChatMessage.fromMap(Map map) {
    return ChatMessage(
      msg: map["msg"],
      time: map["time"],
      msgType: map["msgType"],
      chatId: map["chatId"],
      isSelf: map["msgStatus"] == 1 ? true : false,
    );
  }

  @override
  String toString() => "msg : $msg, time : $time, "
      "msgType : $msgType, chatId : $chatId, isSelf: $isSelf";
}
