import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/models/cupom.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';
import 'package:cs_monetization/ui/widgets/custom_dialogue.dart';
import 'package:flutter/material.dart';

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class GerarTile extends StatelessWidget {
  final String titulo;
  final int valor;
  final Color cor;
  final LinearGradient gradient;
  final Widget image;
  GerarTile(
      {@required this.titulo,
      @required this.valor,
      this.cor,
      this.gradient,
      this.image});
  String _gerarCodigo(int strlen) {
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Cupom x;
    return InkWell(
      onTap: () async {
        DateTime dt = DateTime.now();
        switch (BlocProvider.of<CupomBloc>(context).appAtual) {
          case "CDE_FLUTTER":
            print("Flutter");
            x = await BlocProvider.of<CupomBloc>(context).insert(cupom: {
              "codigo": _gerarCodigo(12),
              "cs": valor,
              "usado": false,
              "dataI": "${dt.day}/${dt.month}/${dt.year}",
              "dataU": "",
              "username": ""
            });
            break;
          case "CDE_UNITY":
            print("Unity");
            x = await BlocProvider.of<CupomBloc>(context).insert(cupom: {
              "codigo": _gerarCodigo(12),
              "cs": valor.toString(),
              "usado": "0",
              "dataI": "${dt.day}/${dt.month}/${dt.year}",
              "dataU": "",
              "username": ""
            });
            break;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(cuppon: x),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: cor != null ? cor : null,
          gradient: gradient != null ? gradient : null,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      valor.toString() + " MZN",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      titulo,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              image
            ],
          ),
        ),
      ),
    );
  }
}
