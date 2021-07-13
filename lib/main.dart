import 'package:e_commerce_app/Providers/auth.dart';
import 'package:e_commerce_app/Providers/cart.dart';
import 'package:e_commerce_app/Providers/orders.dart';
import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:e_commerce_app/screens/auth_screen.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:e_commerce_app/screens/payment_screen.dart';
import 'package:e_commerce_app/screens/products_detail_screen.dart';
import 'package:e_commerce_app/screens/products_overview_screen.dart';
import 'package:e_commerce_app/screens/shopping_bag_screen.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:e_commerce_app/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (_) => ProductsProvider(),
            update: (_, auth, previousProducts) => previousProducts
              ..update(
                auth.tokenMethod,
                auth.userIdMethod,
                previousProducts == null ? [] : previousProducts.items,
              ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (_, auth, previousOrders) => previousOrders
              ..update(
                auth.token,
                auth.userIdMethod,
                previousOrders == null ? [] : previousOrders.order,
              ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
                primaryColor: Color(0xffE8EFF4),
                accentColor: Colors.grey[900],
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductsOverviewScreen.id: (context) => ProductsOverviewScreen(),
              ProductsDetailScreen.id: (context) => ProductsDetailScreen(),
              ShoppingBagScreen.id: (context) => ShoppingBagScreen(),
              OrdersScreen.id: (context) => OrdersScreen(),
              UserProductsScreen.id: (context) => UserProductsScreen(),
              EditProductScreen.id: (context) => EditProductScreen(),
              AuthScreen.id: (context) => AuthScreen(),
              PaymentScreen.id: (context) => PaymentScreen(),
            },
          ),
        ));
  }
}
