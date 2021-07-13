import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static String id = '/user_products_screen';

  Future<void> refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fatchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.id);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshData(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshData(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                  productsData.items[i].title,
                                  productsData.items[i].imageUrl,
                                  productsData.items[i].productId),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
