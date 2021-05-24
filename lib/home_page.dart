import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/authentication.dart';
import 'package:myapp/widgets/top_bar_contents.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import './text/my_extended_text_selection_controls.dart';
import 'package:url_launcher/url_launcher.dart';
import './text/my_special_text_span_builder.dart';
import './widgets/player_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  ScrollController _scrollController;
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    getUserInfo();
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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: TopBarContents(_opacity),
      ),
      body: MyGirdView(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyGirdView extends StatelessWidget {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final String _attachContent =
      '[love]Extended text help you to build rich text quickly. any special text you will have with extended text.It\'s my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[love] if you meet any problem, please let me konw @zmtzawqlp .[sun_glasses]';
  TextSelectionControls _myExtendedMaterialTextSelectionControls;

  @override
  void initState() {

    _myExtendedMaterialTextSelectionControls = MyTextSelectionControls();

  }
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
    return Stack(
      children: [
        Container(
          // image below the top bar

          child: SizedBox(
            height: screenSize.height * 0.45,
            width: screenSize.width,
            child: Image.asset(
              'assets/images/cover.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),

        Center(
          heightFactor: 1,
          child: Padding(
            padding: EdgeInsets.only(
              top: screenSize.height * 0.40,
              left: screenSize.width / 5,
              right: screenSize.width / 5,
            ),
            child: Container(
              child: GridView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: elements.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemBuilder: (context, i) => Card(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SelectableText(elements[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        remoteUrl(),
      ],
    );
  }
}
Widget remoteUrl() {
  return SingleChildScrollView(
    child: Row(
      children: [
        Text(
          'Sample 1 ($kUrl1)',
          key: Key('url1'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: kUrl1),
        Text(
          'Sample 2 ($kUrl2)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: kUrl2),
        Text(
          'Sample 3 ($kUrl3)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: kUrl3),
        Text(
          'Sample 4 (Low Latency mode) ($kUrl1)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        PlayerWidget(url: kUrl1, mode: PlayerMode.LOW_LATENCY),
      ],
    ),
  );
}
class AtText extends SpecialText {
  AtText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
      {this.showAtBackground = false, this.start})
      : super(flag, ' ', textStyle, onTap: onTap);
  static const String flag = '@';
  final int start;

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  InlineSpan finishText() {
    final TextStyle textStyle =
    this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
        background: Paint()..color = Colors.blue.withOpacity(0.15),
        text: atText,
        actualText: atText,
        start: start,

        ///caret can move into special text
        deleteAll: true,
        style: textStyle,
        recognizer: (TapGestureRecognizer()
          ..onTap = () {
            if (onTap != null) {
              onTap(atText);
            }
          }))
        : SpecialTextSpan(
        text: atText,
        actualText: atText,
        start: start,
        style: textStyle,
        recognizer: (TapGestureRecognizer()
          ..onTap = () {
            if (onTap != null) {
              onTap(atText);
            }
          }));
  }
}