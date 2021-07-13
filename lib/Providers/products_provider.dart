import 'package:e_commerce_app/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/Providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String url =
    'https://shop-app-dc207-default-rtdb.firebaseio.com/products';

class ProductsProvider with ChangeNotifier {
  String authToken;
  String userId;
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void update(String auth, String userID, List<Product> prodItems) {
    authToken = auth;
    userId = userID;
    _items = prodItems;
    notifyListeners();
  }

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.productId == id);
  }

  Future<void> fatchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      final response =
          await http.get(Uri.parse('$url.json?auth=$authToken$filterString'));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final urlForFavorites =
          'https://shop-app-dc207-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse = await http.get(Uri.parse(urlForFavorites));
      final favoritesData = json.decode(favoritesResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          productId: prodId,
          title: prodData['title'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          description: prodData['description'],
          isFavorite:
              favoritesData == null ? false : favoritesData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(Uri.parse('$url.json?auth=$authToken'),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
        productId: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.productId == id);
    if (prodIndex >= 0) {
      await http.patch(Uri.parse('$url/$id.json?auth=$authToken'),
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _items.indexWhere((element) => element.productId == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response =
        await http.delete(Uri.parse('$url/$id.json?auth=$authToken'));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete this product !');
    }

    existingProduct = null;
  }
}
