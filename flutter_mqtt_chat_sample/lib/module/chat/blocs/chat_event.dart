import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final BuildContext context;
  final String msg;
  final String chatId;

  const SendMessageEvent(this.context, this.msg, this.chatId);

  @override
  List<Object> get props => [msg, chatId];
}

class SendImageEvent extends ChatEvent {
  final BuildContext context;
  final File imageFile;
  final String chatId;

  const SendImageEvent(this.context, this.imageFile, this.chatId);

  @override
  List<Object> get props => [imageFile, chatId];
}

class ReceivedMessageEvent extends ChatEvent {
  final String chatId;
  final String message;

  const ReceivedMessageEvent(this.chatId, this.message);

  @override
  List<Object> get props => [chatId];
}

class LoadInitialMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadInitialMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class BlockUserEvent extends ChatEvent {
  final BuildContext context;
  final String chatId;
  const BlockUserEvent(this.context, this.chatId);

  @override
  List<Object> get props => [context, chatId];
}

class UnblockUserEvent extends ChatEvent {
  final BuildContext context;
  final String chatId;
  const UnblockUserEvent(this.context, this.chatId);

  @override
  List<Object> get props => [context, chatId];
}
