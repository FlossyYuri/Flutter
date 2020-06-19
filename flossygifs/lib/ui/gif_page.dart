import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _dadosDoGif;
  GifPage(this._dadosDoGif);//Construtor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dadosDoGif['title']),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_dadosDoGif['images']['fixed_height']['url']);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch
        ,
        children: <Widget>[
        Image.network(_dadosDoGif['images']['fixed_height']['url'])
      ],),
    );
  }
}