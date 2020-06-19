import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/models/cupom.dart';
import 'package:flutter/material.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';
import 'package:flutter/services.dart';

class CustomDialog extends StatelessWidget {
  final Cupom cuppon;

  CustomDialog({@required this.cuppon});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    var bloc = BlocProvider.of<CupomBloc>(context);
    int icon = 1;
    switch (cuppon.cs) {
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

    Widget _linha(String campo, String valor) {
      return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "$campo:",
              style: TextStyle(fontSize: 14, letterSpacing: 0.5),
            ),
            Text(
              "$valor",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, letterSpacing: 0.5),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              _linha("Codigo", cuppon.codigo),
              SizedBox(
                height: 4,
              ),
              _linha("Preco", cuppon.cs.toString()),
              SizedBox(
                height: 4,
              ),
              _linha("Criado em", "${cuppon.dataI}"),
              SizedBox(
                height: 4,
              ),
              cuppon.usado
                  ? _linha("Data de uso", "${cuppon.dataU}")
                  : Container(),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Gerar Recibo",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: bloc.geraRecibo(cuppon)),
                        );
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                      splashColor: Colors.blueAccent,
                      shape: StadiumBorder(),
                    ),
                    FlatButton(
                      child: Text(
                        "Enviar recibo",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        bloc.sendMessage(cuppon);
                      },
                      color: Colors.white,
                      splashColor: Colors.blueAccent,
                      shape: StadiumBorder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            height: 120,
            decoration: cuppon.cs == 100
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: cuppon.cs == 200
                        ? RadialGradient(
                            colors: [
                              Color.fromRGBO(235, 18, 107, 1),
                              Color.fromRGBO(166, 13, 75, 1),
                            ],
                          )
                        : RadialGradient(
                            colors: [
                              Color.fromRGBO(237, 217, 13, 1),
                              Color.fromRGBO(237, 172, 34, 1),
                            ],
                          ),
                  ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/icons/gold$icon.png",
                  width: 60,
                ),
                Text(
                  "${cuppon.cs} MZN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
