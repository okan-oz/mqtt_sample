# mqtt_sample
<p>This project is sample for  <a href="https://mqtt.org/"><B>MQTT</B></a> with flutter.</p>
<p>The <a href="https://pub.dev/packages/mqtt_client">MQTT client</a> has been used successfully with the MQTT broker(broker.emqx.io)</p>
<p>You can change default settings on <a href="https://github.com/okan-oz/mqtt_sample/blob/master/flutter_mqtt_chat_sample/lib/module/mqtt/models/mqtt_setting_model.dart">mqtt_setting_model.dart</a>  file and  change another broker.</p>
<p>Also you see the <B>Flutter Bloc</B> sample using for Chat Screen on this project and you can see the using of <B>sqflite</B></p>
<p>Firstly login with your credential .These informations are used for connection the MQTT server.If you want to use one more </p>

<p>HomeBloc(ConnectToServerEvent) is responsible for the open the connection with MQTT.</p>
<p>If you want to use it on more than one device at the same time, you should write different phone numbers. Any verification etc. won't want to.</p>
<img width="379" alt="Screenshot 2022-02-13 at 15 23 32" src="https://user-images.githubusercontent.com/62757704/153769769-9f60ba42-cb4e-4a78-b79e-ecd396f98109.png">
<p>If you want to use it on more than one device at the same time, you should write different phone numbers. Any verification etc. won't be wanted.</p>

<img width="366" alt="Screenshot 2022-02-13 at 15 24 37" src="https://user-images.githubusercontent.com/62757704/153770558-1d09abcf-775e-417e-a381-725bf517c146.png">

![Screenshot 2022-02-13 at 22 06 33](https://user-images.githubusercontent.com/62757704/153770678-d17922cc-73a0-4dae-a5c9-d3fa5d65aca7.png)

<p>You can subscribe to the topic you want on this screen.</p>
![Screenshot 2022-02-13 at 21 42 22](https://user-images.githubusercontent.com/62757704/153770783-11964eba-1d55-40cf-95f8-d831a27f57c5.png)
