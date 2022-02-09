import 'package:flutter/material.dart';
import 'package:flutter_application_chat_sample/splashscreen.dart';
import 'package:flutter_application_chat_sample/utils/SharedObjects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'module/chat/blocs/chat_bloc.dart';
import 'module/home/blocs/home_bloc.dart';
import 'module/mqtt/state_provider/mqtt_state.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedObjects.prefs = await CachedSharedPreferences.getInstance();
  runApp(MultiBlocProvider(
    providers: [
      // BlocProvider<ContactsBloc>(
      //   create: (context) => ContactsBloc(),
      // ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(),
      ),
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(),
      ),
      // BlocProvider<AddFriendsBloc>(
      //   create: (context) => AddFriendsBloc(),
      // ),
      // BlocProvider<TimerBloc>(
      //   create: (context) => TimerBloc(),
      // )
    ],
    child: MyApp(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {

//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ChatHomeScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MQTTState>(create: (context) => MQTTState()),
        // ChangeNotifierProvider<NumberState>(
        //   create: (context) => NumberState(),
        // ),
        // ChangeNotifierProvider<ProfilePicUrlState>(
        //     create: (context) => ProfilePicUrlState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
