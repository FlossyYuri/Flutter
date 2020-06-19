import 'package:flutter/material.dart';
class ListData extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final ImageProvider imagem;
  final EdgeInsets margem;
  ListData({this.titulo, this.imagem, this.margem, this.subtitulo});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margem,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[100], width: 1.0),
          bottom: BorderSide(color: Colors.grey[100], width: 1.0),
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imagem)
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start  ,
            children: <Widget>[
              Text(
                titulo,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5,),
              Text(
                subtitulo,
                style: TextStyle(fontSize: 14,color: Colors.grey, fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      ),
    );
  }
}