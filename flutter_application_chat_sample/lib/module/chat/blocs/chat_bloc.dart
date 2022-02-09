import 'package:flutter_application_chat_sample/module/chat/utils/chat_function.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/models/chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial());

  ChatFunction chatFunction = ChatFunction();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessageEvent) {
      chatFunction.sendMessageToServer(event.context, event.msg, event.chatId);
      yield ChatMessageSent();
    }
    if (event is SendImageEvent) {
      chatFunction.sendImageToServer(event.context, event.imageFile, event.chatId);
      yield ChatImageSent();
    }
    if (event is ReceivedMessageEvent) {
      List<ChatMessage> allMessages = await chatFunction.getAllMsgsFromMessagesTable(event.chatId);
      yield ReceivedMessageState(allMessages, event.message);
    }
    if (event is LoadInitialMessagesEvent) {
      List<ChatMessage> lastChatMsgs = await chatFunction.getAllMsgsFromMessagesTable(event.chatId);
      yield (InitialMessagesLoadedState(lastChatMsgs, ''));
    }
    if (event is BlockUserEvent) {
      chatFunction.blockUser(event.context, event.chatId);
      yield (BlockedUserState());
      // DBManager.db.isBlocked(event.chatId);
    }
    if (event is UnblockUserEvent) {
      chatFunction.unBlockUser(event.context, event.chatId);
      yield (UnblockedUserState());
    }
  }
}
