import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_monetization/data/api.dart';
import 'package:cs_monetization/models/cupom.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class CupomBloc implements BlocBase {
  Api api;
  List<Cupom> cupons;
  List<String> estatisticas;
  String appAtual;
  final StreamController _cuponsController = BehaviorSubject<List<Cupom>>();
  final StreamController _estatisticasController = BehaviorSubject<List<String>>();
  Stream get outcupons => _cuponsController.stream;
  Stream get outestats => _estatisticasController.stream;

  void updateApp() {
    switch (appAtual) {
      case "CDE_FLUTTER":
        appAtual = "CDE_UNITY";
        break;
      case "CDE_UNITY":
        appAtual = "CDE_FLUTTER";
        break;
    }
    _select();
  }

  CupomBloc() {
    appAtual = "CDE_UNITY";
    api = Api();
    estatisticas = [];
    _select();
  }

  _select() async {
    switch (appAtual) {
      case "CDE_FLUTTER":
        cupons = await getCupons();
        
        break;
      case "CDE_UNITY":
        cupons = await api.select();
        estatisticas = await api.getEstatisticas();
        break;
    }
    
    _cuponsController.sink.add(cupons);
    _estatisticasController.sink.add(estatisticas);

  }

  Future<Cupom> insert({Map<String, dynamic> cupom}) async {
    Cupom inserido;
    switch (appAtual) {
      case "CDE_FLUTTER":
        inserido = await insertCupons(cupom: cupom);
        break;
      case "CDE_UNITY":
        inserido = await api.createPost(body: cupom);
        break;
    }
    if (inserido != null) _select();
    return inserido;
  }

  String geraRecibo(Cupom cupom) {
    return '''Comprou um cupom para o jogo Código de Estrada - MZ.
Código do cupom: \"${cupom.codigo}\".
Valor do cupom: ${cupom.cs}CS.
Custo em Meticais: ${cupom.cs}MZN.
Data de criação do cupom: ${cupom.dataI}.''';
  }

  String mes(int mes) {
    switch (mes) {
      case 1:
        return "Janeiro";
      case 2:
        return "Fevereiro";
      case 3:
        return "Março";
      case 4:
        return "Abril";
      case 5:
        return "Maio";
      case 6:
        return "Junho";
      case 7:
        return "Julho";
      case 8:
        return "Agosto";
      case 9:
        return "Setembro";
      case 10:
        return "Outubro";
      case 11:
        return "Novembro";
      case 12:
        return "Dezembro";
      default:
        return "X";
    }
  }

  sendMessage(Cupom cupom) async {
    String url;
    if (Platform.isAndroid) {
      //FOR Android
      url = 'sms:+25884052158?body=${geraRecibo(cupom)}';
      await launch(url);
    } else if (Platform.isIOS) {
      //FOR IOS
      url = 'sms:+25884052158&body=${geraRecibo(cupom)}';
      await launch(url);
    }
  }

  Future<List<Cupom>> getCupons() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("cupons").getDocuments();
    return snapshot.documents.map((snapshot) {
      return Cupom.fromJson(snapshot.data);
    }).toList();
  }

  Future<Cupom> insertCupons({Map<String, dynamic> cupom}) async {
    await Firestore.instance
        .collection("cupons")
        .document(cupom['codigo'])
        .setData(cupom);
    return await getCupom(cupom['codigo']);
  }

  Future<Cupom> getCupom(String codigo) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("cupons").document(codigo).get();
    if (snapshot.exists)
      return Cupom.fromJson(snapshot.data);
    else
      return null;
  }

  @override
  void dispose() {
    _cuponsController.close();
    _estatisticasController.close();
  }
}
