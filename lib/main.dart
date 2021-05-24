import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/image_editor_demo.dart';
import 'package:myapp/image_screen.dart';
import 'package:myapp/image_upload.dart';
import 'package:myapp/pages/audio_player.dart';
import 'package:myapp/text_page.dart';
import './second_screen.dart';
import 'new_image.dart';

void main() {
  runApp(MaterialApp(
    title: 'Image Gallery',
    debugShowCheckedModeBanner: false,
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => MyHomePage(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => SecondScreen(),
      '/image': (context) => ImagePage(),
      '/image_editor': (context) => ImageEditorDemo(),
      '/text': (context) => CustomTextOverflowDemo(),
      '/upload': (context) => ImageUpload(),
      '/upload_image': (context) => UploadImageDemo(),
      '/audio_player': (context) => ExampleApp(),

    },
  ));
}
