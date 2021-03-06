import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homies/screens/home.dart';
import 'package:homies/screens/login.dart';
import 'package:homies/screens/root.dart';
import 'package:homies/service_locator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  try {
    await setupLocator();
    await storeProfileImage();
    runApp(MyApp());
  } catch (e) {
    print(e);
  }
}

Future<void> storeProfileImage() async {
  Directory directory = await getApplicationDocumentsDirectory();
  var imagePath = join(directory.path, "default_profile.png");
  if (FileSystemEntity.typeSync(imagePath) == FileSystemEntityType.notFound) {
    ByteData data = await rootBundle.load("assets/profile.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(imagePath).writeAsBytes(bytes);
  }
}

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