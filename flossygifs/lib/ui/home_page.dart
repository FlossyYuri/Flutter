import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flossygifs/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _pesquisa;
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response resposta;
    if (_pesquisa != null)
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=d7KbMipPzj97Ln3LD0VbT92zWibagK1b&q=$_pesquisa&limit=19&offset=$_offset&rating=G&lang=pt");
    else
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=d7KbMipPzj97Ln3LD0VbT92zWibagK1b&limit=20&rating=G");
    return json.decode(resposta.body);
  }

  int _getTamanho(List data) {
    if (_pesquisa == null)
      return data.length;
    else
      return data.length + 1;
  }

  @override
  void initState() {
    super.initState();
    _getGif().then((map) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Escreva qualquer coisa",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _pesquisa = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _criarTabelaDeGifs(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _criarTabelaDeGifs(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getTamanho(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_pesquisa == null || index < snapshot.data['data'].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GifPage(snapshot.data['data'][index])));
              },
              onLongPress: (){
                Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      size: 72.0,
                      color: Colors.white,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        });
  }
}
