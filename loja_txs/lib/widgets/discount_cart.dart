import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_txs/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style:
              TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite o codigo do cupom"
              ),
              initialValue: CartModel.of(context).cupponCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("cuppons").document(text).get().then((doc){
                  if(doc.data != null){
                    CartModel.of(context).setCuppon(text, doc.data['percent']);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Desconto de ${doc.data['percent']}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor ,)
                    );
                  }else{
                    CartModel.of(context).setCuppon(null, 0);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Cupom nao existente!"),
                      backgroundColor: Colors.redAccent ,)
                    );
                  }
                });
              },
            ),
            
          )
        ],
      ),
      
    );
  }
}
