import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

const request =
    "http://data.fixer.io/api/latest?access_key=b437ee1cbd5a726d8084f395a400c5f9&symbols=USD,AOA,BTC,EUR,ZAR,BRL,MZN";
//"https://api.hgbrasil.com/finance?format=json-cors&key=0cbcd450" br

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(response.body);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controladorReal = TextEditingController();
  final _controladorDolar = TextEditingController();
  final _controladorEuro = TextEditingController();
  final _controladorRand = TextEditingController();
  final _controladorBit = TextEditingController();
  final _controladorKwanza = TextEditingController();
  final _controladorMetical = TextEditingController();
  NumberFormat formater = NumberFormat("###,###,##0.00");
  double dolar, euro, rand, real, bitcoin, kwanza, metical;
  void _resetarCampos() {
    _controladorReal.text = "";
    _controladorDolar.text = "";
    _controladorEuro.text = "";
    _controladorRand.text = "";
    _controladorBit.text = "";
    _controladorKwanza.text = "";
    _controladorMetical.text = "";
  }

  void _realMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.real, valor: double.parse(text));
  }

  void _dolarMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.dolar, valor: double.parse(text));
  }

  void _euroMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.euro, valor: double.parse(text));
  }

  void _meticalMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.metical, valor: double.parse(text));
  }

  void _randMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.rand, valor: double.parse(text));
  }

  void _kwanzaMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.kwanza, valor: double.parse(text));
  }

  void _bitMudou(String text) {
    if (text.isEmpty) {
      _resetarCampos();
      return;
    }
    _converter(moeda: this.bitcoin, valor: double.parse(text));
  }

  void _converter({double moeda, double valor}) {
    print("moeda $moeda, valor: $valor");
    if (moeda != real)
      _controladorReal.text = formater.format(valor * real / moeda);
    if (moeda != dolar)
      _controladorDolar.text = formater.format(valor * dolar / moeda);
    if (moeda != euro)
      _controladorEuro.text = formater.format(valor * euro / moeda);
    if (moeda != metical)
      _controladorMetical.text = formater.format(valor * metical / moeda);
    if (moeda != kwanza)
      _controladorKwanza.text = formater.format(valor * kwanza / moeda);
    if (moeda != rand)
      _controladorRand.text = formater.format(valor * rand / moeda);
    if (moeda != bitcoin)
      _controladorBit.text = formater.format(valor * bitcoin / moeda);

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moeda"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando dados... ',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError)
                return Center(
                  child: Text(
                    'Carregando dados... ',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              else {
                dolar = snapshot.data['rates']['USD'];
                euro = snapshot.data['rates']['EUR'].toDouble();
                rand = snapshot.data['rates']['ZAR'];
                metical = snapshot.data['rates']['MZN'];
                kwanza = snapshot.data['rates']['AOA'];
                real = snapshot.data['rates']['BRL'];
                bitcoin = snapshot.data['rates']['BTC'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Meticais", "MT", _controladorMetical, _meticalMudou),
                      Divider(),
                      buildTextField(
                          "Dolares", "\$", _controladorDolar, _dolarMudou),
                      Divider(),
                      buildTextField(
                          "Euros", "€", _controladorEuro, _euroMudou),
                      Divider(),
                      buildTextField(
                          "Reais", "R\$", _controladorReal, _realMudou),
                      Divider(),
                      buildTextField(
                          "Rands", "R", _controladorRand, _randMudou),
                      Divider(),
                      buildTextField(
                          "Kwanzas", "Kz", _controladorKwanza, _kwanzaMudou),
                      Divider(),
                      buildTextField(
                          "Bitcoins", "₿", _controladorBit, _bitMudou),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    controller: c,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
