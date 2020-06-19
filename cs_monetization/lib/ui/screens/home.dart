import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/ui/tabs/estatisticas.dart';
import 'package:cs_monetization/ui/tabs/gerar.dart';
import 'package:cs_monetization/ui/tabs/visualizar.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(195, 55, 100, 1),
              Color.fromRGBO(29, 38, 113, 1),
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Gerar", icon: Icon(Icons.add_circle_outline)),
              Tab(text: "Visualizar", icon: Icon(Icons.remove_red_eye)),
              Tab(text: "Estatisticas", icon: Icon(Icons.show_chart)),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/cs.png"))),
              ),
              Text(
                "CHILL STUDIO",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          centerTitle: false,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: TabBarView(
            children: [
              GerarTab(),
              VisualizarTab(),
              EstatisticasTab(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: BlocProvider.of<CupomBloc>(context).appAtual == "CDE_FLUTTER"
              ? Text("Flutter")
              : Text("Unity"),
          onPressed: () {
            setState(() {
              BlocProvider.of<CupomBloc>(context).updateApp();
            });
          },
        ),
      ),
    );
  }
}
