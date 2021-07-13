import 'dart:convert';
import 'package:e_commerce_app/Providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String url = 'https://shop-app-dc207-default-rtdb.firebaseio.com/orders';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  String authToken;
  String userId;
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  void update(String auth, String userID, List<OrderItem> prodItems) {
    authToken = auth;
    userId = userID;
    _orders = prodItems;
    notifyListeners();
  }

  Future<void> fatchOrders() async {
    final response =
        await http.get(Uri.parse('$url/$userId.json?auth=$authToken'));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final response =
        await http.post(Uri.parse('$url/$userId.json?auth=$authToken'),
            body: jsonEncode({
              'amount': total,
              'products': cartProducts
                  .map((e) => {
                        'id': e.id,
                        'title': e.title,
                        'price': e.price,
                        'quantity': e.quantity,
                      })
                  .toList(),
              'dateTime': DateTime.now().toIso8601String(),
            }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
