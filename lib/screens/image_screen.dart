import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  String url;
  ImageScreen({this.url});
  @override
  _ImageScreenState createState() => _ImageScreenState(url);
}

class _ImageScreenState extends State<ImageScreen> {
  final String url;

  _ImageScreenState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("image Screen"),
      ),
      body:Center(
          child: PhotoView(
            imageProvider: NetworkImage(url),
          )
      ),
    );
  }
}
