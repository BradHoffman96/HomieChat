import 'package:flutter/material.dart';
import 'package:homie_chat/provider_setup.dart';
import 'package:homie_chat/ui/router.dart';
import 'package:homie_chat/ui/views/login_view.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';

Future main() async {
  var providers = await getProviders();

  runApp(MyApp(providers: providers));
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Iterable<SingleChildCloneableWidget> providers;

  MyApp({this.providers});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran s"flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: RoutePaths.Root,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }

  Widget _getStartupScreen() {


  }
}