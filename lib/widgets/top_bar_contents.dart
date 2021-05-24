import 'package:flutter/material.dart';
import 'package:myapp/widgets/google_signin_button.dart';
import '../gallery_screen.dart';
import '../main.dart';
import '../utils/authentication.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;
  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
  ];
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: widget.opacity != 1
            ? Theme.of(context).bottomAppBarColor.withOpacity(widget.opacity)
            : Colors.blue[200],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                'Image Gallery',
                style: TextStyle(color: Colors.blue),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[0] = true
                              : _isHovering[0] = false;
                          print(_isHovering);
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(
                          color: _isHovering[0] == true
                              ? Colors.purple[800]
                              : Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[1] = true
                              : _isHovering[1] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pushNamed(context, '/second');
                      },
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color:
                              _isHovering[1] ? Colors.purple[800] : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width / 50,
              ),
              InkWell(
                onHover: (value) {
                  setState(() {
                    value ? _isHovering[3] = true : _isHovering[3] = false;
                  });
                },
                onTap: () {
                  Navigator.pushNamed(context, '/image_editor');
                },
                child: Text(
                  'Image Editor',
                  style: TextStyle(
                    color: _isHovering[3] ? Colors.purple[800] : Colors.blue,
                  ),
                ),
              ),
              InkWell(
                  child: userEmail == null
                      ? GoogleButton()
                      : FlatButton(
                          color: Colors.blueGrey,
                          hoverColor: Colors.blueGrey[700],
                          highlightColor: Colors.blueGrey[800],
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  await signOut().then((result) {
                                    print(result);
                                    Navigator.pushNamed(context, '/');
                                  }).catchError((error) {
                                    print('Sign Out Error: $error');
                                  });
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text(
                                    name + ' (Sign out)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
