// ignore_for_file: avoid_unnecessary_containers
import 'dart:async';
import 'package:flutter_emoji/flutter_emoji.dart' as emj;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../config/design_constants.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';
import '../models/models/chat_message.dart';
import '../widgets/chat_item_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  final String topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String lastSendMessage = '';
  String lastReceivedMessage = '';
  late ChatBloc chatBloc;
  List<ChatMessage> allMessages = [];
  late ScrollController _scrollController;
  TextEditingController chatTextController = TextEditingController();
  var parser = emj.EmojiParser();

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(LoadInitialMessagesEvent(widget.topic));
    _scrollController = ScrollController();
  }

  void sendMessage(String message) {
    // mqttClientManager.publishMessage(message, widget.topic);
    chatBloc.add(SendMessageEvent(context, message, widget.topic));
  }

  Widget _buildTypeMessageTextField() {
    return Expanded(
      flex: 5,
      child: Row(
        children: [
          Expanded(
            child: Neumorphic(
              margin: const EdgeInsets.only(left: 6, right: 5, top: 2, bottom: 4),
              style: const NeumorphicStyle(
                depth: -15,
                boxShape: NeumorphicBoxShape.stadium(),
                shadowDarkColorEmboss: Colors.black,
                shadowLightColor: Colors.white,
                intensity: 0.6,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                onTap: () {
                  // scroll to the bottom of the list when keyboard appears
                  Timer(
                      const Duration(milliseconds: 200),
                      () => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500), curve: Curves.easeIn));
                },
                focusNode: FocusNode(),
                cursorColor: Colors.blueGrey,
                controller: chatTextController,
                style: const TextStyle(
                  fontSize: 21.0,
                ),
                decoration: const InputDecoration.collapsed(hintText: "Type a message"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton(double algo) {
    return Expanded(
      child: InkWell(
        onTap: () {
          String tempChatId = widget.topic;
          String msgToSend = parser.unemojify(chatTextController.text);

          chatBloc.add(SendMessageEvent(context, msgToSend, tempChatId));
          // userDataFunction.sendNotification(
          //   toUid: widget.toContact.phoneNumber,
          //   title: "${widget.toContact.name}",
          //   content: msgToSend,
          // );
          chatTextController.clear();
        },
        child: Neumorphic(
          style: kCircleNeumorphicStyle,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: algo * 33.0,
            child: Neumorphic(
              style: const NeumorphicStyle(
                shadowDarkColor: Colors.blueGrey,
                boxShape: NeumorphicBoxShape.circle(),
                depth: 4,
                intensity: 0.7,
                surfaceIntensity: 0.6,
              ),
              child: CircleAvatar(
                radius: algo * 23.0,
                backgroundColor: Colors.white,
                child: Icon(Icons.send, color: Colors.blueGrey, size: algo * 26.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double algo = screenWidth / perfectWidth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.topic}'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: BlocListener<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ReceivedMessageState) {
                    if (state.chatMessages[0].chatId == widget.topic) {
                      setState(() {
                        allMessages = state.chatMessages;
                      });
                    }
                  }
                  if (state is InitialMessagesLoadedState) {
                    setState(() {
                      allMessages = state.chatMessages;
                    });
                  }
                  Timer(
                     const Duration(milliseconds: 600),
                      () => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration:const Duration(milliseconds: 200), curve: Curves.easeIn));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: algo * 8.0),
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        return ChatItemWidget(
                          message: allMessages[index],
                        );
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _buildTypeMessageTextField(),
                  _buildSendButton(algo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
