import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/conversation.dart';
import '../../mqtt/utils/mqtt_function.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  MQTTFunction mqttFunction = MQTTFunction();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is ConnectToServerEvent) {
      try {
        await mqttFunction.connect(event.context);
      } catch (e) {
        debugPrint("Couln't Connect to Server. Most Probably Internet is Off");
      }
      add(FetchHomeChatsEvent());
    }
    if (event is DisconnectEvent) {
      mqttFunction.disconnect();
    }
    if (event is FetchHomeChatsEvent) {
      yield* mapFetchHomeChatsEventToState();
    }
  }

  Stream<HomeState> mapFetchHomeChatsEventToState() async* {
    List<Conversation> conversations = [];
    // ignore: todo
    // //TODO: Implement
    // List<Map<dynamic, dynamic>> dbData =
    //     await DBManager.db.getAlConversationsFromChatTable();

    // dbData.forEach((dbMap) {
    //   conversations.add(Conversation.fromMap(dbMap));
    // });

    // conversations.sort((b, a) => a.time.compareTo(b.time));

    yield (FetchedHomeChatsState(conversations));
  }
}
