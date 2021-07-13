import 'package:e_commerce_app/Providers/auth.dart';
import 'package:e_commerce_app/Providers/cart.dart';
import 'package:e_commerce_app/Providers/product.dart';
import 'package:e_commerce_app/screens/products_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProductsDetailScreen.id,
                  arguments: product.productId);
            },
            child: Hero(
              tag: product.productId,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.fill,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          //to refresh buttom not all weggit when when pressed buttom
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.deepOrange,
              onPressed: () {
                product.toggleFavoriteStatus(
                    authToken.token, authToken.userIdMethod);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_bag,
            ),
            color: Colors.deepOrange,
            onPressed: () {
              cart.addItem(product.productId, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Add item to bag!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  textColor: Colors.deepOrange,
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.productId);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
