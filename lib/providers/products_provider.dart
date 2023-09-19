import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // FETCHED DATA ...
  ];

  // bool _favoritesOnly = false;

  List<Product> get items {
    // _items is private property so it cannot be accessed from outside the class
    // if (_favoritesOnly) {
    //   return _items.where((product) => product.isFavourite).toList();
    // }
    return [
      ..._items
    ]; // items is a copy of _items, and it is a public property
  }

  List<Product> get favoritesItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://my-shop-194bf-default-rtdb.firebaseio.com/products.json');
    final products = {
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavourite,
    };
    try {
      final response = await http.post(
        url,
        body: json.encode(products),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    // _items.insert(0, newProduct); // To add at the begining of the list
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://my-shop-194bf-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      final fetchedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> extractedData = [];
      fetchedProducts.forEach((key, value) {
        extractedData.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
          ),
        );
      });
      _items = extractedData;
    } catch (e) {
      rethrow;
    }
  }

  void updateProduct(Product product, String id) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    _items[productIndex] = product;
    notifyListeners();
  }

  Product findById(id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  void removeProduct(id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
