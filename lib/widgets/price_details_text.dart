import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PriceDetailsText extends StatelessWidget {
  PriceDetailsText({
    @required this.title,
    @required this.cost,
  });
  final String title;
  final String cost;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Spacer(),
        Text(
          cost,
          style: TextStyle(fontSize: 17),
        ),
        Text(
          ' EGP',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
