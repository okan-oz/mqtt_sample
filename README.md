# MQTT Sample  with Chat
<p>This project is sample for  <a href="https://mqtt.org/"><B>MQTT</B></a> with flutter.</p>

![Screenshot 2022-02-13 at 22 06 33](https://user-images.githubusercontent.com/62757704/153771718-9ab4a625-9e9d-49e6-a0f5-36a195d90a51.png)

<p>The <a href="https://pub.dev/packages/mqtt_client">MQTT client</a> has been used successfully with the MQTT broker(broker.emqx.io)</p>
<p>You can change default settings on <a href="https://github.com/okan-oz/mqtt_sample/blob/master/flutter_mqtt_chat_sample/lib/module/mqtt/models/mqtt_setting_model.dart">mqtt_setting_model.dart</a>  file and  change another broker.</p>
<p>Also you see the state management <B>Flutter Bloc</B> and <b>Provider</b>  samples using for Chat Screen on this project and you can see the using of <B>sqflite</B></p>
<p>Firstly login with your credential .These informations are used for connection the MQTT server.</p>

<p>HomeBloc(ConnectToServerEvent) is responsible for the open the connection with MQTT.</p>

<img width="379" alt="Screenshot 2022-02-13 at 15 23 32" src="https://user-images.githubusercontent.com/62757704/153769769-9f60ba42-cb4e-4a78-b79e-ecd396f98109.png">
<p>If you want to use it on more than one device at the same time, you should write different phone numbers. Any verification etc. won't be wanted.</p>

<img width="366" alt="Screenshot 2022-02-13 at 15 24 37" src="https://user-images.githubusercontent.com/62757704/153770558-1d09abcf-775e-417e-a381-725bf517c146.png">

<p>You can subscribe to the topic you want on this screen.</p>

![Screenshot 2022-02-13 at 21 42 22](https://user-images.githubusercontent.com/62757704/153770799-ccb8740a-9e0c-495b-97ba-8f6c054c5d06.png)

You can review <a href="https://github.com/okan-oz/mqtt_sample/blob/master/flutter_mqtt_chat_sample/lib/module/mqtt/utils/mqtt_manager.dart">this</a> file for details of mqtt operations.

 
