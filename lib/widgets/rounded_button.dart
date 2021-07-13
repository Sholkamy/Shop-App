import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    @required this.radiusValue,
    @required this.title,
    @required this.toDo,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.minWidthValue = 0,
    this.minheightValue = 0,
  });

  final Function toDo;
  final double radiusValue;
  final String title;
  final double verticalPadding;
  final double horizontalPadding;
  final double minWidthValue;
  final double minheightValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Material(
        elevation: 5.0,
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(radiusValue),
        child: MaterialButton(
          onPressed: toDo,
          minWidth: minWidthValue,
          height: minheightValue,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
