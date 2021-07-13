import 'package:e_commerce_app/Providers/orders.dart' show Orders;
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String id = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fatchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.order.length,
                  itemBuilder: (context, i) =>
                      OrderItem(order: orderData.order[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
