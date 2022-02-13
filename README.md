# mqtt_sample
<p>This project is sample for <B>MQTT</B>(https://mqtt.org/) with flutter.</p>
<p>The <a href="https://pub.dev/packages/mqtt_client">MQTT client</a> has been used successfully with the MQTT broker(broker.emqx.io)</p>
<p>You can change default settings on <a href="https://github.com/okan-oz/mqtt_sample/blob/master/flutter_mqtt_chat_sample/lib/module/mqtt/models/mqtt_setting_model.dart">mqtt_setting_model.dart</a>  file and  change another broker.</p>
<p>Also you see the <B>Flutter Bloc</B> sample using for Chat Screen on this project and you can see the using of <B>sqflite</p>
<p>Firstly login your credential .These informations are used for connection the MQTT server.</p>

HomeBloc(ConnectToServerEvent) is responsible for the open the connection with MQTT.
<img width="379" alt="Screenshot 2022-02-13 at 15 23 32" src="https://user-images.githubusercontent.com/62757704/153769769-9f60ba42-cb4e-4a78-b79e-ecd396f98109.png">




