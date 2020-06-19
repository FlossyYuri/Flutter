import 'dart:convert';
import 'package:cs_monetization/models/cupom.dart';
import 'package:http/http.dart' as http;

const SELECT_CUPONS =
    "http://flossyyuri.com/appFlutter/sqlSelectCuppons.php";
const ESTATISTICAS = "http://flossyyuri.com/app/estatisticas.php";
const INSERT_CUPONS =
    "http://flossyyuri.com/appFlutter/sqlInsertCuppon.php";

class Api {
  Future<List<Cupom>> select() async {
    http.Response response = await http.get(SELECT_CUPONS);
    return decode(response);
  }

  Future<List<String>> getEstatisticas() async {
    http.Response response = await http.get(ESTATISTICAS);
    if (response.statusCode == 200) {
      return response.body.split(";");
    } else {
      throw Exception("Failed on that");
    }
  }

  Cupom decodeSingle(http.Response response) {
    var decoded = json.decode(response.body);
    if (decoded['ok']) {
      return Cupom.fromJsonWeb(decoded['cuppon']);
    }
    return null;
  }

  List<Cupom> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      List<Cupom> cupons = decoded.map<Cupom>((map) {
        return Cupom.fromJsonWeb(map);
      }).toList();
      return cupons;
    } else {
      throw Exception("Failed on that");
    }
  }

  Future<Cupom> createPost({Map body}) async {
    return http.post(INSERT_CUPONS, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return decodeSingle(response);
    });
  }
}
