import 'dart:async';
import 'package:flutter_emoji/flutter_emoji.dart' as emj;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/module/chat/models/models/chat_message.dart';
import 'package:flutter_application_chat_sample/widgets/image_full_screen_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../config/design_constants.dart';
import '../blocs/chat_bloc.dart';
import '../blocs/chat_event.dart';
import '../blocs/chat_state.dart';
import '../widgets/chat_item_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.topic}) : super(key: key);

  final String topic; // TODO ?

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              margin: EdgeInsets.only(left: 6, right: 5, top: 2, bottom: 4),
              style: NeumorphicStyle(
                depth: -15,
                boxShape: NeumorphicBoxShape.stadium(),
                shadowDarkColorEmboss: Colors.black,
                shadowLightColor: Colors.white,
                intensity: 0.6,
              ),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: TextField(
                onTap: () {
                  // scroll to the bottom of the list when keyboard appears
                  Timer(
                      Duration(milliseconds: 200),
                      () => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500), curve: Curves.easeIn));
                },
                focusNode: FocusNode(),
                cursorColor: Colors.blueGrey,
                controller: chatTextController,
                style: TextStyle(
                  fontSize: 21.0,
                ),
                decoration: InputDecoration.collapsed(hintText: "Type a message"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactProfilePicture(double algo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageFullScreenWidget()));
      },
      child: Hero(
        tag: 'Tag',
        child: Neumorphic(
          style: kCircleNeumorphicStyle,
          child: CircleAvatar(
            radius: algo * 23.5,
            backgroundImage: CachedNetworkImageProvider('https://upload.wikimedia.org/wikipedia/commons/0/0a/Gnome-stock_person.svg'),
          ),
        ),
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
              style: NeumorphicStyle(
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

                  // jump to the bottom of the screen when a new message arrives
                  // also using a timer because we need to jump to the bottom
                  // only after the new message is updated in the listview
                  Timer(
                      Duration(milliseconds: 600),
                      () => _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
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
            Row(
              children: [
                _buildTypeMessageTextField(),
                _buildSendButton(algo),
              ],
            ),
          ],
        ),
      ),

      // body: Scrollbar(
      //   child: SingleChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: Column(
      //         children: [
      //           BlocConsumer<ChatBloc, ChatState>(
      //             bloc: chatBloc,
      //             listener: (BuildContext context, ChatState state) {
      //               if (state is ReceivedMessageState) {
      //               } else if (state is ChatMessageSent) {}
      //             },
      //             builder: (BuildContext context, ChatState state) {
      //               if (state is ReceivedMessageState) {
      //                 return Text(state.lastMessage);
      //               } else if (state is InitialMessagesLoadedState) {
      //                 return const Text('No Content');
      //               } else if (state is ChatMessageSent) {
      //                 return const Text('Message has been send');
      //               } else {
      //                 return const SizedBox.shrink();
      //               }
      //             },
      //           ),
      //           const SizedBox(
      //             height: 20,
      //           ),
      //           Form(
      //             key: _formKey,
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   flex: 9,
      //                   child: TextFormField(
      //                     minLines: 1,
      //                     maxLines: 1,
      //                     initialValue: '',
      //                     decoration: const InputDecoration(
      //                       border: OutlineInputBorder(),
      //                       hintText: '',
      //                       label: Text('Send Messages'),
      //                     ),
      //                     onSaved: (String? value) {
      //                       lastSendMessage = value!;
      //                     },
      //                   ),
      //                 ),
      //                 Expanded(
      //                   flex: 1,
      //                   child: IconButton(
      //                     onPressed: () {
      //                       _formKey.currentState!.save();
      //                       sendMessage(lastSendMessage);
      //                     },
      //                     icon: const Icon(
      //                       Icons.send_rounded,
      //                       size: 30,
      //                       color: Colors.blue,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    chatTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
