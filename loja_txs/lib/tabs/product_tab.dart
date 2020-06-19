import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_txs/widgets/category_tile.dart';

class TabProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("produtos").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return ListView(
            children: ListTile.divideTiles(context: context, tiles: 
              snapshot.data.documents.map((doc) {
                    return CategoryTile(doc);
              }).toList()
            ).toList()
          );

        }
      },
    );
  }
}
