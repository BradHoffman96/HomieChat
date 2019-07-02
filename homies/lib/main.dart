import 'package:flutter/material.dart';
import 'package:homies/screens/home.dart';
import 'package:homies/screens/login.dart';
import 'package:homies/screens/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomieChat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MHomePage(title: 'Flutter Demo Home Page'),
      home: RootPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage()
      },
    );
  }
}