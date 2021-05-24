import 'package:flutter/material.dart';
import 'package:myapp/widgets/top_bar_contents.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import './utils/crop_editor_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import './common/image_picker.dart';

class ImagePage extends StatefulWidget {

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  double _opacity = 1;

  ScrollController _scrollController;

  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();
  final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
  GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
  bool _cropping = false;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _opacity = 0.5;

    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: TopBarContents(_opacity),
      ),
      body: MyGirdView(),
    );
  }
}

class MyGirdView extends StatelessWidget {

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  final List<String> elements = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "A Million Billion Trillion",
    "A much, much longer text that will still fit"
  ];

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    String url =
        'https://p.bigstockphoto.com/GeFvQkBbSLaMdpKXF1Zv_bigstock-Aerial-View-Of-Blue-Lakes-And--227291596.jpg';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo_library),

                ),
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    if (kIsWeb) {
                      print('testss');
                      _cropImage(false);
                    } else {
                      _showCropDialog(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.65,
          width: screenSize.width,
          child: ExtendedImage.network(
            'https://i.picsum.photos/id/1045/3936/2624.jpg?hmac=PMfAbC94Asle_jgeRYsj7zQHFabfTfsIwL247Ewetwc',
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: editorKey,
            initEditorConfigHandler: (state) {
              return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio: CropAspectRatios.custom);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.restore),
                  onPressed: () {
                    //crop images
                    editorKey.currentState.reset();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Reset")
              ],
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.rotate_left),
                  onPressed: () {
                    //rotate left
                    editorKey.currentState.rotate(right: false);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Rotate-Left")
              ],
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.rotate_right),
                  onPressed: () {
                    //rotate right
                    editorKey.currentState.rotate(right: true);
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Rotate-Right")
              ],
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.flip),
                  onPressed: () {
                    //flip images
                    editorKey.currentState.flip();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Flip")
              ],
            )
          ],
        )
      ],
    );
  }
}

class CropAspectRatios {
  /// no aspect ratio for crop
  static const double custom = null;

  /// the same as aspect ratio of image
  /// [cropAspectRatio] is not more than 0.0, it's original
  static const double original = 0.0;

  /// ratio of width and height is 1 : 1
  static const double ratio1_1 = 1.0;

  /// ratio of width and height is 3 : 4
  static const double ratio3_4 = 3.0 / 4.0;

  /// ratio of width and height is 4 : 3
  static const double ratio4_3 = 4.0 / 3.0;

  /// ratio of width and height is 9 : 16
  static const double ratio9_16 = 9.0 / 16.0;

  /// ratio of width and height is 16 : 9
  static const double ratio16_9 = 16.0 / 9.0;
}

class EditorCropLayerPainter {
  const EditorCropLayerPainter();
  void paint(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    paintMask(canvas, size, painter);
    paintLines(canvas, size, painter);
    paintCorners(canvas, size, painter);
  }

  /// draw crop layer corners
  void paintCorners(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}

  /// draw crop layer lines
  void paintMask(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}

  /// draw crop layer lines
  void paintLines(
      Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}
}

void _showCropDialog(BuildContext context) {

  showDialog<void>(
      context: context,
      builder: (BuildContext content) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
                margin: const EdgeInsets.all(20.0),
                child: Material(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'select library to crop',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Image',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decorationStyle:
                                        TextDecorationStyle.solid,
                                        decorationColor: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {

                                      }),
                                const TextSpan(
                                    text:
                                    '(Dart library) for decoding/encoding image formats, and image processing. It\'s stable.')
                              ],
                            ),
                            const TextSpan(text: '\n\n'),
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'ImageEditor',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decorationStyle:
                                        TextDecorationStyle.solid,
                                        decorationColor: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {

                                      }),
                                const TextSpan(
                                    text:
                                    '(Native library) support android/ios, crop flip rotate. It\'s faster.')
                              ],
                            )
                          ])),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              OutlinedButton(
                                child: const Text(
                                  'Dart',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _cropImage(false);
                                },
                              ),
                              OutlinedButton(
                                child: const Text(
                                  'Native',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _cropImage(true);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
            Expanded(
              child: Container(),
            )
          ],
        );
      });
}

Future<void> _cropImage(bool useNative) async {
  bool _cropping = false;
  if (_cropping) {
    return;
  }
  String msg = '';
  try {
    _cropping = true;
    final GlobalKey<ExtendedImageEditorState> editorKey =
    GlobalKey<ExtendedImageEditorState>();
    final GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>> popupMenuKey =
    GlobalKey<PopupMenuButtonState<EditorCropLayerPainter>>();
    //await showBusyingDialog();

    Uint8List fileData;

    /// native library
    if (useNative) {
      fileData = await cropImageDataWithNativeLibrary(
          state: editorKey.currentState);
    } else {
      ///delay due to cropImageDataWithDartLibrary is time consuming on main thread
      ///it will block showBusyingDialog
      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      //await Future.delayed(Duration(milliseconds: 200));

      ///if you don't want to block ui, use compute/isolate,but it costs more time.
      fileData =
      await cropImageDataWithDartLibrary(state: editorKey.currentState);
    }
    final String filePath =
    await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
    // var filePath = await ImagePickerSaver.saveFile(fileData: fileData);

    msg = 'save image : $filePath';
  } catch (e, stack) {
    msg = 'save failed: $e\n $stack';
    print(msg);
  }
  _cropping = false;
  //Navigator.of(context).pop();
}