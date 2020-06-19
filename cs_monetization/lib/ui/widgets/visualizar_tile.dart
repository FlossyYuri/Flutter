import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/models/cupom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';

class VisualizarTile extends StatelessWidget {
  final Cupom cupom;
  VisualizarTile({@required this.cupom});
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<CupomBloc>(context);
    int icon = 1;
    switch (cupom.cs) {
      case 100:
        icon = 1;
        break;
      case 200:
        icon = 2;
        break;
      case 500:
        icon = 3;
        break;
    }
    return InkWell(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: cupom.cs < 200
              ? BoxDecoration(
                  color: Color.fromRGBO(0, 145, 234, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)))
              : BoxDecoration(
                  gradient: cupom.cs == 200
                      ? LinearGradient(
                          colors: [
                              Color.fromRGBO(166, 13, 75, 1),
                              Color.fromRGBO(235, 18, 107, 1)
                            ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      : LinearGradient(
                          colors: [
                              Color.fromRGBO(237, 172, 34, 1),
                              Color.fromRGBO(237, 217, 13, 1)
                            ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/icons/gold$icon.png",
                          width: 60,
                        ),
                        Text(
                          "${cupom.cs} MZN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Codigo",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          "${cupom.codigo}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          "Preco",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          "${cupom.cs},00 MT",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          "Data de criação",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        Text(
                          "${cupom.dataI}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                        cupom.usado
                            ? Text(
                                "Data de uso",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    letterSpacing: 0.5),
                              )
                            : Container(),
                        cupom.usado
                            ? Text(
                                "${cupom.dataU}",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    letterSpacing: 0.5),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: cupom.usado
                    ? <Widget>[]
                    : <Widget>[
                        FlatButton(
                          child: Text(
                            "Gerar Recibo",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 145, 234, 1)),
                          ),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text: bloc.geraRecibo(cupom)));
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Copiado para clipboard"),
                              backgroundColor: Color.fromRGBO(195, 55, 100, 1),
                            ));
                          },
                          color: Colors.white,
                          splashColor: Color.fromRGBO(0, 145, 234, 1),
                          shape: StadiumBorder(),
                        ),
                        FlatButton(
                          child: Text(
                            "Enviar recibo",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 145, 234, 1)),
                          ),
                          onPressed: () {
                            bloc.sendMessage(cupom);
                          },
                          color: Colors.white,
                          splashColor: Color.fromRGBO(0, 145, 234, 1),
                          shape: StadiumBorder(),
                        ),
                      ],
              )
            ],
          )),
    );
  }
}
