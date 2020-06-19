import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_txs/data/cart_product.dart';
import 'package:loja_txs/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  bool isLoading = false;
  List<CartProduct> produtos = [];
  String cupponCode;
  int discountPercent = 0;
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItens();
    }
  }
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);
  void addCardItem(CartProduct cp) {
    produtos.add(cp);
    Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cp.toMap())
        .then((doc) {
      cp.cid = doc.documentID;
    });
    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (produtos.length == 0) return null;
    isLoading = true;
    double total = getProcutsPrice();
    double ship = getShipPrice();
    double disc = getDiscount();

    DocumentReference ref = await Firestore.instance.collection("pedidos").add({
      "idCliente": user.firebaseUser.uid,
      "produtos": produtos.map((cp) => cp.toMap()).toList(),
      "precoEnvio": ship,
      "precoProdutos": total,
      "disconto": disc,
      "precoTotal": total - disc + ship,
      "status": 1,
    });

    await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("pedidos")
        .document(ref.documentID)
        .setData({"idPedido": ref.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    produtos.clear();
    cupponCode = null;
    discountPercent = 0;
    isLoading = false;
    notifyListeners();

    return ref.documentID;
  }

  double getProcutsPrice() {
    double price = 0;
    for (CartProduct c in produtos) {
      if (c.productData != null) price += c.quantidade * c.productData.preco;
    }
    return price;
  }

  double getDiscount() {
    return getProcutsPrice() * discountPercent / 100;
  }

  double getShipPrice() {
    return 200.0;
  }

  void setCuppon(String cuppon, int disc) {
    this.cupponCode = cuppon;
    this.discountPercent = disc;
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantidade--;
    Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantidade++;
    Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void removeCartItem(CartProduct cp) {
    Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cp.cid)
        .delete();
    produtos.remove(cp);
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    produtos =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}
