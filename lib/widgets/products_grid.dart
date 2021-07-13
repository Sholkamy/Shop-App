import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:e_commerce_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.showFavorites);
  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts =
        showFavorites ? productsData.favoritesItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //Number of photos in one row
        crossAxisCount: 2,
        //Aspect Ratio
        childAspectRatio: 6 / 8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
