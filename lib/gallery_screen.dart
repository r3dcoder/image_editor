import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'widgets/top_bar_contents.dart';
import 'package:flutter/foundation.dart';

class GalleryImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryDemo(),
    );
  }
}

class GalleryDemo extends StatefulWidget {
  GalleryDemo({Key key}) : super(key: key);

  @override
  _GalleryDemoState createState() => _GalleryDemoState();
}

class _GalleryDemoState extends State<GalleryDemo> {
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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: TopBarContents(_opacity),
      ),
      body: Center(
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
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image:
                                        new NetworkImage(snapshot.data[index]),
                                    fit: BoxFit.cover))));
                  });
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
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

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
