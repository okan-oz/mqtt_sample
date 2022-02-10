import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../chat/screens/chat_screen.dart';
import '../../mqtt/state_provider/mqtt_state.dart';
import '../../mqtt/utils/mqtt_manager.dart';
import '../blocs/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late HomeBloc homeBloc;
  String currentSelectedTopic = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void setUserNameAndNameIfNull() {}

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
    homeBloc.add(ConnectToServerEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Home'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 1,
                  initialValue: 'test/topic1',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Topic',
                    label: Text('Topic'),
                  ),
                  onSaved: (String? value) {
                    currentSelectedTopic = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        // mqttClientManager.subcribeTopic(currentSelectedTopic);
                        MQTTManager? manager = context.read<MQTTState>().manager;
                        debugPrint("SUBSCRIBING TO TOPIC : $currentSelectedTopic");
                        manager!.subscribeTopic(currentSelectedTopic);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    topic: currentSelectedTopic,
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      homeBloc.add(DisconnectEvent());
    }
    if (state == AppLifecycleState.resumed) {
      homeBloc.add(ConnectToServerEvent(context));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
