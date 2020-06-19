import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String idPedido;
  OrderScreen(this.idPedido);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Realizados"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
              size: 100.0,
            ),
            Text("Pedido realizado com sucesso!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Codigo do pedido: $idPedido", style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}
