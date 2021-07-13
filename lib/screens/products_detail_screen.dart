import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsDetailScreen extends StatelessWidget {
  static String id = '/products_detail_screen';
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(context).settings.arguments as String;
    final loadedProducts =
        Provider.of<ProductsProvider>(context).findById(productid);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(loadedProducts.title),
              background: Hero(
                tag: loadedProducts.productId,
                child: Image.network(
                  loadedProducts.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 20),
            Text(
              loadedProducts.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '${loadedProducts.price}EGP',
              style: TextStyle(
                color: Color(0xFF41C5D3),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProducts.description,
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800)
          ]))
        ],
      ),
    );
  }
}
