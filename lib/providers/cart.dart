import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.00;
    _items.forEach((key, cartItm) {
      total += (cartItm.quantity * cartItm.price);
    });
    return total;
  }

  int get itemCount {
    try {
      return _items.length;
    } catch (e) {
      return 0;
    }
  }

  void testFunc() {
    try {
      print(items.length);
    } catch (e) {
      print(0);
    }
  }

  void addItem(String id, double price, String title) {
    if (_items.containsKey(id)) {
      // increase quantity
      _items.update(
          id,
          (existingProduct) => CartItem(
              id: existingProduct.id,
              title: existingProduct.title,
              quantity: existingProduct.quantity + 1,
              price: existingProduct.price));
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    var qtty = _items[id]?.quantity ?? 0;
    if (qtty > 1) {
      _items.update(
        id,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            title: existingProduct.title,
            quantity: existingProduct.quantity - 1,
            price: existingProduct.price),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
