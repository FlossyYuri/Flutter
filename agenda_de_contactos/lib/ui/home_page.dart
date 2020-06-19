import 'dart:io';
import 'package:agenda_de_contactos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_de_contactos/helpers/contacto_helper.dart';
import 'package:url_launcher/url_launcher.dart';

enum OpcoesOrdem { ordemAZ, ordemZA }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contacto> contactos;
  @override
  void initState() {
    super.initState();
    // Contacto c = Contacto();
    // c.nome = "Eddy Buque";
    // c.phone = "848870122";
    // c.email = "eddy@gmail.com";
    // helper.salvarContacto(c);
    _getTodosContactos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contactos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OpcoesOrdem>(
            itemBuilder: (context) => <PopupMenuEntry<OpcoesOrdem>>[
              const PopupMenuItem<OpcoesOrdem>(
                child: Text("Ordenar de A-Z"),
                value: OpcoesOrdem.ordemAZ,
              ),
              const PopupMenuItem<OpcoesOrdem>(
                child: Text("Ordenar de Z-A"),
                value: OpcoesOrdem.ordemZA,
              ),
            ],
            onSelected: _listaOrdem,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarContacto,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contactos.length,
        itemBuilder: (context, index) {
          return _cartaoContactos(context, index);
        },
      ),
    );
  }

  Widget _cartaoContactos(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contactos[index].img != null
                            ? FileImage(File(contactos[index].img))
                            : AssetImage('assets/images/avatar.png'),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contactos[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contactos[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contactos[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _mostrarOpcoes(context, index);
      },
    );
  }

  void _mostrarOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        ),
                        onPressed: () {
                          launch("tel:${contactos[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _mostrarContacto(contacto: contactos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        ),
                        onPressed: () {
                          helper.deleteContacto(contactos[index].id);
                          setState(() {
                            contactos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _mostrarContacto({Contacto contacto}) async {
    final contactoRecebido = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contacto: contacto,
                )));
    if (contactoRecebido != null) {
      if (contacto != null) {
        await helper.updateContacto(contactoRecebido);
      } else {
        await helper.salvarContacto(contactoRecebido);
      }
      _getTodosContactos();
    }
  }

  void _getTodosContactos() {
    helper.getTodosContactos().then((lista) {
      contactos = lista;
      setState(() {
      });
    });
  }

  void _listaOrdem(OpcoesOrdem resultados) {
    switch (resultados) {
      case OpcoesOrdem.ordemAZ:
        contactos.sort((a,b){
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OpcoesOrdem.ordemZA:
        contactos.sort((a,b){
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }
}
