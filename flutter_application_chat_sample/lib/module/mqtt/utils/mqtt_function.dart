// import 'package:coocoo/config/Constants.dart';
// import 'package:coocoo/functions/BaseFunctions.dart';
// import 'package:coocoo/managers/mqtt_manager.dart';
// import 'package:coocoo/stateProviders/mqtt_state.dart';
// import 'package:coocoo/utils/SharedObjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/module/mqtt/models/mqtt_setting_model.dart';
import 'package:provider/provider.dart';
import '../../../config/constants.dart';
import '../../../core/abstract/base_functions.dart';
import '../../../utils/SharedObjects.dart';
import '../state_provider/mqtt_state.dart';
import 'mqtt_manager.dart';

class MQTTFunction extends BaseMQTTFunction {
  MQTTManager? _manager;
  String? loggedInUser;

  @override
  Future<void> connect(BuildContext context) async {
    loggedInUser = SharedObjects.prefs.getString(Constants.sessionUid);
    _manager = context.read<MQTTState>().manager;

    final String password = "S8x${loggedInUser?.substring(1, 6)}S,.@";

    if (_manager == null) {
      _manager = MQTTManager(
        context: context,
      );

      _manager!.initialize(MqttSettingModel.test());

      // also set the mqtt_manager to the provider
      context.read<MQTTState>().setNewManager(_manager!);
      print(_manager);
    }

    print("Connecting to server");
    //await _manager!.connect(loggedInUser, password);
    await _manager!.connect();
  }

  @override
  void dispose() {}

  @override
  void disconnect() {
    if (_manager != null) {
      _manager!.disconnect();
    }
  }
}
