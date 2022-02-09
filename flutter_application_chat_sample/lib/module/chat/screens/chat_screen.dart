import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mqtt/utils/mqtt_manager.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  final String topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String lastSendMessage = '';
  String lastReceivedMessage = '';
  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(LoadInitialMessagesEvent(widget.topic));
  }

  void sendMessage(String message) {
    // mqttClientManager.publishMessage(message, widget.topic);
    chatBloc.add(SendMessageEvent(context, message, widget.topic));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.topic}'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                BlocConsumer<ChatBloc, ChatState>(
                  bloc: chatBloc,
                  listener: (BuildContext context, ChatState state) {
                    if (state is ReceivedMessageState) {
                    } else if (state is ChatMessageSent) {}
                  },
                  builder: (BuildContext context, ChatState state) {
                    if (state is ReceivedMessageState) {
                      return Text(state.lastMessage);
                    } else if (state is InitialMessagesLoadedState) {
                      return const Text('No Content');
                    } else if (state is ChatMessageSent) {
                      return const Text('Message has been send');
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 1,
                          initialValue: '',
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '',
                            label: Text('Send Messages'),
                          ),
                          onSaved: (String? value) {
                            lastSendMessage = value!;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            sendMessage(lastSendMessage);
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
