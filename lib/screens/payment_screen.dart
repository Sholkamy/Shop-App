import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = '/payment_screen';

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Bag'),
      ),
      body: WebView(
        onPageFinished: (page) {},
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://www.paypal.com/eg/signin',
      ),
    );
  }
}
