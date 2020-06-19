import 'package:flutter/material.dart';
import 'package:loja_txs/tabs/home_tab.dart';
import 'package:loja_txs/tabs/order_tab.dart';
import 'package:loja_txs/tabs/places_tab.dart';
import 'package:loja_txs/tabs/product_tab.dart';
import 'package:loja_txs/widgets/cart_button.dart';
import 'package:loja_txs/widgets/custom_drawer.dart';
class HomeScreen extends StatelessWidget {
  final _controladorPaginas = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controladorPaginas,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_controladorPaginas),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_controladorPaginas),
          body: TabProdutos(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_controladorPaginas),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_controladorPaginas),
        )
      ],
    );
  }
}