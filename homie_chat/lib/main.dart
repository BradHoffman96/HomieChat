import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homie_chat/provider_setup.dart';
import 'package:homie_chat/ui/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import 'core/constants/app_constants.dart';

Future main() async {
  var providers = await getProviders();
  await storeProfileImage();

  runApp(MyApp(providers: providers));
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
}