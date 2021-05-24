import 'package:flutter/material.dart';
import 'package:myapp/widgets/top_bar_contents.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import './widgets/player_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';
class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  double _opacity = 1;
  ScrollController _scrollController;

  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: TopBarContents(_opacity),
      ),
      body: Column(
        children: [
          Center(
            child: FutureBuilder<List<String>>(
              future: fetchGalleryData(),
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.hasData) {
                  return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenSize.width > 750 ? 8 : 3),
                      itemBuilder: (context, index) {
                        return ExtendedImage.network(
                          snapshot.data[index],
                          fit: BoxFit.contain,
                          //enableLoadState: false,
                          mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                              minScale: 0.9,
                              animationMinScale: 0.7,
                              maxScale: 3.0,
                              animationMaxScale: 3.5,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              inPageView: false,
                              initialAlignment: InitialAlignment.center,
                            );
                          },

                        );
                      });
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          remoteUrl(),
        ],
      ),
    );
  }
}

Widget remoteUrl() {
  return Expanded(
    child: SingleChildScrollView(
      child: Column(
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
    ),
  );
}
Future<List<String>> fetchGalleryData() async {
  List data = [];
  List<String> imgUrl = [];
  try {
    http.Response response = await http
        .get(Uri.parse(
            'https://api.unsplash.com/photos/?client_id=mue4cOzLZCxi5X0JN0CmJqzHHb6mm2h5GDjCee4ddHA'))
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        imgUrl.add(data.elementAt(i)["urls"]["regular"]);
      }
      return imgUrl;
      // return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

