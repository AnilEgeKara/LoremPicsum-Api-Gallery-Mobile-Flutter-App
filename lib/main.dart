import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Offset _offset = Offset(0.2, 0.6);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page()
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {

  Future<List<Album>> _fetchData() async {
    return http.get('https://picsum.photos/v2/list') .then((value) {
      if(value.statusCode == 200){
        print('girdi 200');
        final jsonData = json.decode(value.body);
        final album = <Album>[];
        for(var i in jsonData){
          album.add(Album.fromJson(i));
        }
        print('for bitti');
        return album;
      }else{
        return null;
      }
    });
  }

  bool isloading =false;
  List<Album> album ;
  @override
  void initState()  {
    _fechDataAsync();
    super.initState();
  }

  _fechDataAsync() async{
    setState(() {
      isloading = true;
    });
    album = await _fetchData();
    print('girdi async');
    print(album[1].author);
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lorem Picsum Gallery ',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: isloading?CircularProgressIndicator():
        GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
            ),
            itemCount: album.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: (){
                  showDialog(context: context, child:
                  MyDialog(author:album[index].author,width:album[index].width,height:album[index].height,download_url:album[index].download_url,url: album[index].url,)
                  );
                  setState(() {
                    _offset = Offset(0.2, 0.6);
                  });
                },
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    album[index].download_url,
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(2),
                ),
              );
            }),
      ),
    );
  }
}


class Album {
  final String id;
  final String author;
  final String width;
  final String height;
  final String url;
  final String download_url;

  Album({this.id, this.author, this.width,this.height,this.url,this.download_url,});
  
  factory Album.fromJson(Map<String,dynamic>jsonData){
    return Album(
      id: jsonData['id'],
      author: jsonData['author'],
      width: jsonData['width'].toString(),
      height: jsonData['height'].toString(),
      url: jsonData['url'],
      download_url: jsonData['download_url'],
    );
  }

}


class MyDialog extends StatefulWidget {
  final String author;
  final String width;
  final String height;
  final String url;
  final String download_url;

  const MyDialog({Key key, this.url, this.author, this.width, this.height, this.download_url}) : super(key: key);
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  openURL(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else {
      throw 'Could not open url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.002 * _offset.dy)
              ..rotateY(-0.003 * _offset.dx),
            alignment: FractionalOffset.center,
            child: GestureDetector(
              onPanUpdate: (details) => setState(() => _offset += details.delta),
              onDoubleTap: () => setState(() => _offset = Offset(0.2, 0.6)),
              child: Card(
                color: Colors.transparent,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  widget.download_url,
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:16),
            padding: EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:4.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Taken by : ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        TextSpan(text: widget.author,style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:4.0),
                  child:RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Dimentions : ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        TextSpan(text: widget.width+'x'+widget.height,style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Visit : ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
                    InkWell(onTap:(){openURL(widget.url);},child: Container(width: MediaQuery.of(context).size.width*0.6,child: Text(widget.url,overflow:TextOverflow.ellipsis ,maxLines: 1,style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,fontSize: 14)))),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      elevation: 24,
    );
  }
}