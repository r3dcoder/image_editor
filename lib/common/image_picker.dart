@JS()
library image_saver;

// ignore:avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html';

import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:js/js.dart';
import 'dart:html' as html; //ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js; // ignore: avoid_web_libraries_in_flutter
@JS()
external void _exportRaw(String key, Uint8List value);

class ImageSaver {
  static Future<String> save(String name, Uint8List fileData) async {
    print(name);
    _exportRaw(name, fileData);

    return name;
  }
}
class ImageSaver1 {
  static void  save(List<int> bytes, String fileName)
  => js.context.callMethod("saveAs", [html.Blob([bytes]), fileName]);
}

Future<Uint8List> pickImage(BuildContext context) async {
  final Completer<Uint8List> completer = Completer<Uint8List>();
  final InputElement input = document.createElement('input') as InputElement;

  input
    ..type = 'file'
    ..accept = 'image/*';
  input.onChange.listen((Event e) async {
    final List<File> files = input.files;
    final reader = FileReader();
    reader.readAsArrayBuffer(files[0]);
    reader.onError
        .listen((ProgressEvent error) => completer.completeError(error));
    await reader.onLoad.first;
    completer.complete(reader.result as Uint8List);
  });
  input.click();
  return completer.future;
}