import 'dart:math';

import 'package:flutter/material.dart';
import 'package:e_commerce_app/Providers/orders.dart' as ordersProvider;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  OrderItem({this.order});
  final ordersProvider.OrderItem order;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded ? (widget.order.products.length * 22.0 + 110) : 100,
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() => expanded = !expanded);
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(vertical: 4),
              height: expanded ? (widget.order.products.length * 22.0 + 10) : 0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${prod.quantity} x  ${prod.price} EGP',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
