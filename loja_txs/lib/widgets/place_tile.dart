import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  PlaceTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 120,
            child: Image.network(
              snapshot.data['imagem'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data['titulo'],
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  snapshot.data['endereco'],
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("Ver no mapa"),
                textColor: Colors.blue,
                padding: EdgeInsets.all(4),
                onPressed: () {
                  launch(
                      "https://www.google.com/maps/search/?api=1&query=${snapshot.data['lat']},${snapshot.data['long']}");
                },
              ),
              FlatButton(
                child: Text("Ligar"),
                textColor: Colors.blue,
                padding: EdgeInsets.all(4),
                onPressed: () {
                  launch("tel:${snapshot.data['telefone']}");
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
