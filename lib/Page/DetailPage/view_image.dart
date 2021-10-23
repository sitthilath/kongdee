import 'package:buddhistauction/WidgetStatic/widget_static.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImage extends StatefulWidget {
  final List<String> image;

  const ViewImage({Key key, @required this.image}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.image.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.image[index]));
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: WidgetStatic.buildLoadingCat(),
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Card(
      color: Colors.transparent,
      shape: CircleBorder(),
      shadowColor: Colors.white,
      child: IconButton(
        color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
    );
  }
}
