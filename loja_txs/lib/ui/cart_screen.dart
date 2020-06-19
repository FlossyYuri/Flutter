import 'package:flutter/material.dart';
import 'package:loja_txs/models/cart_model.dart';
import 'package:loja_txs/models/user_model.dart';
import 'package:loja_txs/ui/login_screen.dart';
import 'package:loja_txs/ui/order_screen.dart';
import 'package:loja_txs/widgets/cart_price.dart';
import 'package:loja_txs/widgets/cart_tile.dart';
import 'package:loja_txs/widgets/discount_cart.dart';
import 'package:loja_txs/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.produtos.length;
                return Text(
                  "${p ?? 0}  ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        print(model.isLoading);
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Faca o login para adicionar ao carinho",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  child: Text("Entra", style: TextStyle(fontSize: 18.0)),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            ),
          );
        } else if (model.produtos == null || model.produtos.length == 0) {
          return Center(
              child: Text(
            "Nenhum  produto no cariho",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ));
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.produtos.map((product) {
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(() async {
                String idPedido = await model.finishOrder();
                if (idPedido != null)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderScreen(idPedido)));
              }),
            ],
          );
        }
      }),
    );
  }
}
