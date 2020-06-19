import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_txs/data/product_data.dart';

class CartProduct {
  String cid;
  String categoria;
  String pid;
  int quantidade;
  String tamanho;
  ProductData productData;
  CartProduct.fromDocument(DocumentSnapshot doc){
    cid = doc.documentID;
    categoria = doc.data['categoria'];
    pid = doc.data['pid'];
    quantidade = doc.data['quantidade'];
    tamanho = doc.data['tamanho'];
  }
  CartProduct();
  Map<String,dynamic> toMap(){
    return {
      'categoria':categoria,
      'pid':pid,
      'quantidade':quantidade,
      'tamanho':tamanho,
      'produto':productData.toResumeMap()
    };
  }
}