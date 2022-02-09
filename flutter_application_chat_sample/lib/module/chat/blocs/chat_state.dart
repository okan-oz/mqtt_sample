import 'package:equatable/equatable.dart';
import '../models/models/chat_message.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> chatMessages;
  final String lastMessage;

  const ChatState(this.chatMessages, this.lastMessage);
    @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {
  ChatInitial() : super([], '');
  @override
  List<Object> get props => [];
}
class ChatMessageSent extends ChatState {
  ChatMessageSent() : super([], '');
  @override
  List<Object> get props => [];
}

class ChatImageSent extends ChatState {
  ChatImageSent() : super([], '');
  @override
  List<Object> get props => [];
}

class ReceivedMessageState extends ChatState {
  final List<ChatMessage> chatMessages;
  final String lastMessage;

  const ReceivedMessageState(this.chatMessages, this.lastMessage) : super(chatMessages, lastMessage);

  @override
  List<Object> get props => [chatMessages];
}

class InitialMessagesLoadedState extends ChatState {
  final List<ChatMessage> chatMessages;
  final String lastMessage;
  const InitialMessagesLoadedState(this.chatMessages,this.lastMessage) : super(chatMessages, lastMessage);

  @override
  List<Object> get props => [chatMessages];
}

class BlockedUserState extends ChatState {
  BlockedUserState() : super([],'');
  @override
  List<Object> get props => [];
}

class UnblockedUserState extends ChatState {
  UnblockedUserState() : super([],'');

  @override
  List<Object> get props => [];
}
