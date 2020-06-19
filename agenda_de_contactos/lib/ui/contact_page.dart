import 'dart:io';

import 'package:agenda_de_contactos/helpers/contacto_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contacto contacto;

  ContactPage({this.contacto});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contacto _contactoEditado;
  bool _editado = false;
  final _focoNome = FocusNode();
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contacto == null) {
      _contactoEditado = Contacto();
    } else {
      _contactoEditado = Contacto.fromMap(widget.contacto.toMap());
      _controladorNome.text = _contactoEditado.nome;
      _controladorEmail.text = _contactoEditado.email;
      _controladorPhone.text = _contactoEditado.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contactoEditado.nome ?? "Novo Contacto"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contactoEditado.nome != null &&
                _contactoEditado.nome.isNotEmpty) {
              Navigator.pop(context, _contactoEditado);
            } else {
              FocusScope.of(context).requestFocus(_focoNome);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _contactoEditado.img != null
                              ? FileImage(File(_contactoEditado.img))
                              : AssetImage('assets/images/avatar.png'),
                          fit: BoxFit.cover)),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    _editado = true;
                    setState(() {
                      _contactoEditado.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text) {
                  _editado = true;
                  setState(() {
                    _contactoEditado.nome = text;
                    if (_editado) {
                      print("ok");
                    }
                  });
                },
                controller: _controladorNome,
                focusNode: _focoNome,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (text) {
                  _editado = true;
                  _contactoEditado.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _controladorEmail,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Telefone",
                ),
                onChanged: (text) {
                  _editado = true;
                  _contactoEditado.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _controladorPhone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_editado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alteracoes?"),
              content: Text("Se sair, as alteracoes serao perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
