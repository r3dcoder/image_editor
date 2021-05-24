import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;

  class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File _image;
  final picker = ImagePicker();
  String base64Image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // base64Image = base64Encode(_image.readAsBytesSync());
        print("test "+pickedFile.path);
        getHttp();
        // uploadImage(_image.path.toString(), _image.readAsBytesSync());

        // _asyncFileUpload(_image);

      } else {
        print('No image selected.');
      }
    });
  }
  Future uploadImages(filename) async{
    var uri = 'https://api.imgur.com/3/image';
    print("file "+filename);
    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    if (res.statusCode == 200) print('Uploaded!');
    return res.reasonPhrase;
  }

  Future<bool> uploadImage(
      String imageFilePath,
      Uint8List imageBytes,
      ) async {
    String url = "https://api.imgur.com/3/image";
    PickedFile imageFile = PickedFile(imageFilePath);
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

    var uri = Uri.parse(url);
    int length = imageBytes.length;
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('files', stream, length,
        filename: basename(imageFile.path),
        contentType: MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  _asyncFileUpload( File file) async{

    var url = Uri.parse('https://api.imgur.com/3/image');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('picture', file.path));
    var res = await request.send();
    return res.reasonPhrase;
  }
  void getHttp() async {


    try {


      var response = await dio.Dio().post('https://api.imgur.com/3/image', data:{"image":"https://imgur.com/YQXzcRi"});
      print(response);
    } catch (e) {
      print(e);
    }
  }
  uploadImageWithhttp(File imageFile) async {
    print(imageFile.path);
    final bytes =  File(imageFile.path).readAsBytesSync();
    print('file . '+bytes.toString());
    String img64 = base64Encode(bytes);
    print('file '+img64);
    var postBody= {

      'image': imageFile != null ? base64Encode(imageFile.readAsBytesSync()) : '',
    };
    var url = Uri.parse('https://api.imgur.com/3/image');
    final response = await http.post(
      url,
      headers: {
        //AuthUtils.AUTH_HEADER: _authToken
        'Content-Type' : 'application/json',
      },
      body: '',
    );

    final responseJson = json.decode(response.body);

    print(".. "+responseJson);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : kIsWeb? Image.network(_image.path):Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}