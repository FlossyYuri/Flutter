import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String idPedido;
  OrderTile(this.idPedido);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection("pedidos")
              .document(idPedido)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int status = snapshot.data['status'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Codigo do pedido: ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(_buildProductText(snapshot.data)),
                  SizedBox(height: 4,),
                  Text(
                    "Status do pedido",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle("1", "Preparacao", status, 1),
                      _linha(),
                      _buildCircle("2", "Transporte", status, 2),
                      _linha(),
                      _buildCircle("3", "Entrega", status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductText(DocumentSnapshot snapshot) {
    String text = "Descricao:\n";
    for (LinkedHashMap p in snapshot.data['produtos']) {
      text +=
          "${p['quantidade']} x ${p['produto']['titulo']} (${p['produto']['preco']} MT)\n";
    }
    text += "Total: ${snapshot.data['precoTotal']}";
    return text;
  }
  Widget _linha(){
    return Container(
      height: 1,
      width: 50,
      color: Colors.grey[500],
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backcolor;
    Widget child;
    if (status < thisStatus) {
      backcolor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backcolor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backcolor = Colors.green;
      child = Icon(Icons.check,color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backcolor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
