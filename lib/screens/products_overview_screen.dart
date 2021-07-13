import 'package:e_commerce_app/Providers/cart.dart';
import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:e_commerce_app/screens/shopping_bag_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/badge.dart';
import 'package:e_commerce_app/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

enum FiltterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static String id = '/products_overview_screen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavoritesOnly = false;
  var isLoading = false;

  Future<void> refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fatchProducts();
  }

  @override
  void initState() {
    setState(() => isLoading = true);
    Provider.of<ProductsProvider>(context, listen: false)
        .fatchProducts()
        .then((_) {
      setState(() => isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FiltterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FiltterOptions.Favorites)
                    showFavoritesOnly = true;
                  else
                    showFavoritesOnly = false;
                });
              },
              icon: Icon(Icons.more_vert_sharp),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FiltterOptions.Favorites),
                    PopupMenuItem(
                        child: Text('Show All'), value: FiltterOptions.All),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.pushNamed(context, ShoppingBagScreen.id);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: RefreshIndicator(
            onRefresh: () => refreshData(context),
            child: ProductsGrid(showFavoritesOnly)),
      ),
    );
  }
}
