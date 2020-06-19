import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controladorPeso = TextEditingController();
  TextEditingController controladorAltura = TextEditingController();
  String _info = "Informe os seus dados:";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetarTela() {
    controladorPeso.text = "";
    controladorAltura.text = "";
    setState(() {
      _info = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcularIMC() {
    setState(() {
      double peso = double.parse(controladorPeso.text);
      double altura = double.parse(controladorAltura.text) / 100;
      double resultado = peso / (altura * altura);
      _info =
          "Paragens Retardado,você nâo é obeso (${resultado.toStringAsPrecision(4)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetarTela,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.people_outline,
                size: 120.0,
                color: Colors.green,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                controller: controladorPeso,
                validator: (value) {
                  if (value.isEmpty) return "Insira seu peso.";
                  return "";
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                controller: controladorAltura,
                validator: (value) {
                  if (value.isEmpty) return "Insira sua Altura.";
                  return "";
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Container(
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) _calcularIMC();
                    },
                    child: Text(
                      'Calcular',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                  height: 50.0,
                ),
              ),
              Text(
                _info,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
