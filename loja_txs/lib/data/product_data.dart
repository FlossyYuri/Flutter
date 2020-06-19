import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String titulo;
  String descricao;
  double preco;
  List imagens;
  List tamanho;
  String categoria;
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    titulo = snapshot.data['titulo'];
    descricao = snapshot.data['descricao'];
    preco = snapshot.data['preco'] + 0.0;
    imagens = snapshot.data['imagens'];
    tamanho = snapshot.data['tamanho'];
  }

  Map<String, dynamic> toResumeMap() {
    return {'titulo': titulo, 'descricao': descricao, 'preco': preco};
  }
}
