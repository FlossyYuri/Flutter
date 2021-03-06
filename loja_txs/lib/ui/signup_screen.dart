import 'package:flutter/material.dart';
import 'package:loja_txs/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    validator: (text) {
                      if (text.isEmpty) return "Nome Invalido";
                      return null;
                    },
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "Email invalido";
                      return null;
                    },
                    controller: _emailController,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha invalida";
                      return null;
                    },
                    controller: _passController,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Endereco"),
                    validator: (text) {
                      if (text.isEmpty) return "Endereco invalida";
                      return null;
                    },
                    controller: _adressController,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "nome": _nameController.text,
                            "email": _emailController.text,
                            "adress": _adressController.text
                          };
                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSucess: _onSucess,
                              onFail: _onFail);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuario criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuario!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
