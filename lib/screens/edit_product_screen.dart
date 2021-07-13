import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:e_commerce_app/Providers/product.dart';
import 'package:e_commerce_app/Providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static String id = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool isInit = true;
  bool isLoading = false;
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final form = GlobalKey<FormState>();
  Product newAddedProduct = Product(
    productId: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        newAddedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        initValue = {
          'title': newAddedProduct.title,
          'price': newAddedProduct.price.toString(),
          'description': newAddedProduct.description,
          'imageUrl': '',
        };
        imageUrlController.text = newAddedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.removeListener(updateImageUrl);
    super.dispose();
  }

  void updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') &&
              !imageUrlController.text.endsWith('.jpg') &&
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    if (!form.currentState.validate()) return;

    form.currentState.save();
    setState(() => isLoading = true);
    try {
      if (newAddedProduct.productId != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(newAddedProduct.productId, newAddedProduct);
        // setState(() => isLoading = false);
        // Navigator.of(context).pop();
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(newAddedProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(), child: Text('Okay'))
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: saveForm,
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: form,
            child: ListView(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.purpleAccent),
                  child: TextFormField(
                    cursorColor: Colors.purpleAccent,
                    initialValue: initValue['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(priceFocusNode);
                    },
                    onSaved: (value) {
                      newAddedProduct = Product(
                        productId: newAddedProduct.productId,
                        title: value,
                        description: newAddedProduct.description,
                        price: newAddedProduct.price,
                        imageUrl: newAddedProduct.imageUrl,
                        isFavorite: newAddedProduct.isFavorite,
                      );
                    },
                    validator: (value) {
                      return value.isEmpty ? 'Please enter a value!' : null;
                    },
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.purpleAccent),
                  child: TextFormField(
                    cursorColor: Colors.purpleAccent,
                    initialValue: initValue['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(descriptionFocusNode);
                    },
                    onSaved: (value) {
                      newAddedProduct = Product(
                        productId: newAddedProduct.productId,
                        title: newAddedProduct.title,
                        description: newAddedProduct.description,
                        price: double.parse(value),
                        imageUrl: newAddedProduct.imageUrl,
                        isFavorite: newAddedProduct.isFavorite,
                      );
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a price!';
                      if (double.parse(value) <= 0)
                        return 'Please enter a number greater than zero!';
                      return null;
                    },
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Colors.purpleAccent),
                  child: TextFormField(
                    cursorColor: Colors.purpleAccent,
                    initialValue: initValue['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: descriptionFocusNode,
                    onSaved: (value) {
                      newAddedProduct = Product(
                        productId: newAddedProduct.productId,
                        title: newAddedProduct.title,
                        description: value,
                        price: newAddedProduct.price,
                        imageUrl: newAddedProduct.imageUrl,
                        isFavorite: newAddedProduct.isFavorite,
                      );
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter a description!';
                      if (value.length < 10)
                        return 'Should be at least 10 characters long.';
                      return null;
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: imageUrlController.text.isEmpty
                            ? Center(child: Text('Enter a Url'))
                            : FittedBox(
                                child: Image.network(
                                  imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              )),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Colors.purpleAccent),
                        child: TextFormField(
                          cursorColor: Colors.purpleAccent,
                          decoration: InputDecoration(labelText: 'Image Url'),
                          keyboardType: TextInputType.url,
                          controller: imageUrlController,
                          focusNode: imageUrlFocusNode,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                            setState(() {});
                          },
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            newAddedProduct = Product(
                              productId: newAddedProduct.productId,
                              title: newAddedProduct.title,
                              description: newAddedProduct.description,
                              price: newAddedProduct.price,
                              imageUrl: value,
                              isFavorite: newAddedProduct.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an image URL.';
                            }
                            try {
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                            } catch (e) {
                              return 'Please enter a valid image URL.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
