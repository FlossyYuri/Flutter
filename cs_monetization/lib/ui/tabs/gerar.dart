import 'package:cs_monetization/ui/widgets/gerar_tile.dart';
import 'package:flutter/material.dart';

class GerarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GerarTile(
            titulo: "Cuppon Essencial",
            valor: 100,
            image: Image.asset("assets/icons/gold1.png", height: 50,),
            cor: Color.fromRGBO(0, 145, 234, 1),
          ),
          GerarTile(
            titulo: "Cuppon Standard",
            valor: 200,
            image: Image.asset("assets/icons/gold2.png", height: 48,),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(166, 13, 75, 1),
              Color.fromRGBO(235, 18, 107, 1)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          GerarTile(
            titulo: "Cuppon Dexule",
            valor: 500,
            image: Image.asset("assets/icons/gold3.png", height: 60,),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(237, 172, 34, 1),
              Color.fromRGBO(237, 217, 13, 1)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
        ],
      ),
    ));
  }
}
