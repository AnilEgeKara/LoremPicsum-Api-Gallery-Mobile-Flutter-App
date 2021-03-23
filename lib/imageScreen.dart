import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageSrceen extends StatefulWidget {
  @override
  _ImageSrceenState createState() => _ImageSrceenState();
}
final _transformationController = TransformationController();
TapDownDetails _doubleTapDetails;
class _ImageSrceenState extends State<ImageSrceen> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:16.0,horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 22,
                        )
                    ),
                    InkWell(
                        onTap: (){
                          _moreInformation(context,arguments);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.white,
                          size: 22,
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height*0.1)),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.9,
            child: GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(arguments['download_url']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _handleDoubleTapDown(TapDownDetails details) {
  _doubleTapDetails = details;
}

void _handleDoubleTap() {
  if (_transformationController.value != Matrix4.identity()) {
    _transformationController.value = Matrix4.identity();
  } else {
    final position = _doubleTapDetails.localPosition;
    // For a 3x zoom
    _transformationController.value = Matrix4.identity()
      ..translate(-position.dx * 2, -position.dy * 2)
      ..scale(3.0);
    // Fox a 2x zoom
    // ..translate(-position.dx, -position.dy)
    // ..scale(2.0);
  }
}

void _moreInformation(context,arguments){
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.cameraRetro,
                    color: Colors.black,
                    size: 22,
                  ),
                  title: new Text(arguments['author']),
              ),
              new ListTile(
                leading:FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.black,
                  size: 22,
                ),
                title: new Text(arguments['width']+' x '+arguments['height']),
              ),
              new ListTile(
                leading:FaIcon(
                  FontAwesomeIcons.link,
                  color: Colors.black,
                  size: 22,
                ),
                title: new Text(arguments['url'],overflow:TextOverflow.ellipsis ,maxLines: 1,style: TextStyle(fontWeight:FontWeight.bold,color: Colors.blue,decoration: TextDecoration.underline,fontSize: 14)),
              ),
            ],
          ),
        );
      }
  );
}