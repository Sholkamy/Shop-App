import 'package:e_commerce_app/Providers/cart.dart' show Cart;
import 'package:e_commerce_app/Providers/orders.dart';
import 'package:e_commerce_app/screens/payment_screen.dart';
import 'package:e_commerce_app/widgets/badge.dart';
import 'package:e_commerce_app/widgets/cart_item.dart';
import 'package:e_commerce_app/widgets/price_details_text.dart';
import 'package:e_commerce_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class ShoppingBagScreen extends StatefulWidget {
  static String id = '/shopping_bag_screen';

  @override
  _ShoppingBagScreenState createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Bag'), actions: <Widget>[
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {},
          ),
        ),
      ]),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration,
                        onChanged: (value) {},
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Apply'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[900],
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              PriceDetailsText(
                  title: 'Subtotal', cost: cart.totalAmount.toStringAsFixed(2)),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Container(height: 0.5, color: Colors.white),
              ),
              PriceDetailsText(title: 'Shipping', cost: '10.0'),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Container(height: 0.5, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: PriceDetailsText(
                    title: 'Bag Total',
                    cost: (cart.totalAmount + 10.0).toStringAsFixed(2)),
              ),
              RoundedButton(
                radiusValue: 20.0,
                title: 'Proceed to Checkout',
                toDo: (cart.totalAmount <= 0)
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        await Provider.of<Orders>(context, listen: false)
                            .addOrder(cart.items.values.toList(),
                                cart.totalAmount + 10.0);
                        setState(() => isLoading = false);
                        cart.clearCart();
                      },
                verticalPadding: 6.0,
                horizontalPadding: 25.0,
                minWidthValue: 200.0,
                minheightValue: 42.0,
              ),
              RoundedButton(
                radiusValue: 20.0,
                title: 'Buy with Payoal',
                toDo: () => Navigator.of(context).pushNamed(PaymentScreen.id),
                verticalPadding: 6.0,
                horizontalPadding: 25.0,
                minWidthValue: 200.0,
                minheightValue: 42.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
