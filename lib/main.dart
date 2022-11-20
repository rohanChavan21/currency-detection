import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:helping_hands/splashscreen.dart';
import 'package:hexcolor/hexcolor.dart';

List<CameraDescription> cameras = cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    highlightColor: HexColor('#A8DEE0'),
    splashColor: HexColor('#F9E2AE'),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helping Hands',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}
