import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem(this.title, this.imageUrl, this.id);
  final String title;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(
                  context, EditProductScreen.id,
                  arguments: id),
              color: Theme.of(context).accentColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to remove this product?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            try {
                              await Provider.of<ProductsProvider>(context,
                                      listen: false)
                                  .deleteProduct(id);
                            } catch (error) {
                              scaffoldMessenger.showSnackBar(SnackBar(
                                content: Text(
                                  'Deleting Failed !',
                                  textAlign: TextAlign.center,
                                ),
                              ));
                            }
                          },
                          child: Text('Yes')),
                    ],
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
