import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _tarefas = [];
  Map<String, dynamic> _ultimoRemovido;
  int _posUltimoRemovido;
  @override
  void initState() {
    super.initState();
    _lerDados().then((dados) {
      setState(() {
        _tarefas = json.decode(dados);
      });
    });
  }

  final _controladorTarefa = TextEditingController();
  void _addTarefa() {
    setState(() {
      Map<String, dynamic> novaTarefa = Map();
      novaTarefa['titulo'] = _controladorTarefa.text;
      novaTarefa['concluido'] = false;
      _controladorTarefa.text = "";
      _tarefas.add(novaTarefa);
      _salvarDados();
    });
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  Future<File> _salvarDados() async {
    String dados = json.encode(_tarefas);
    final file = await _getFile();
    return file.writeAsString(dados);
  }

  Future<String> _lerDados() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget construirItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_tarefas[index]["titulo"]),
        value: _tarefas[index]["concluido"],
        secondary: CircleAvatar(
          child: Icon(_tarefas[index]["concluido"] ? Icons.check : Icons.error),
        ),
        onChanged: (val) {
          setState(() {
            _tarefas[index]['concluido'] = val;
            _salvarDados();
          });
        },
      ),
      onDismissed: (direcao) {
        setState(() {
          _ultimoRemovido = Map.from(_tarefas[index]);
          _posUltimoRemovido = index;
          _tarefas.removeAt(index);
          _salvarDados();
          final snack = SnackBar(
            content: Text("Tarefa \"${_ultimoRemovido['titulo']}\" removida"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _tarefas.insert(_posUltimoRemovido, _ultimoRemovido);
                  _salvarDados();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _tarefas.sort((a, b) {
        if (a['concluido'] && !b['concluido'])
          return 1;
        else if (!a['concluido'] && b['concluido'])
          return -1;
        else
          return 0;
      });
      _salvarDados();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    controller: _controladorTarefa,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addTarefa,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 5.0),
                itemCount: _tarefas.length,
                itemBuilder: construirItem,
              ),
            ),
          )
        ],
      ),
    );
  }
}
