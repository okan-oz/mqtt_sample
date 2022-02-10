
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/constants.dart';
import '../../../core/abstract/base_functions.dart';
import '../../../utils/shared_objects.dart';
import '../models/mqtt_setting_model.dart';
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
      _manager!.initialize(MqttSettingModel.setDefault(username: loggedInUser!, userPassword: password));

      // also set the mqtt_manager to the provider
      context.read<MQTTState>().setNewManager(_manager!);
    }
    debugPrint("Connecting to server");
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
