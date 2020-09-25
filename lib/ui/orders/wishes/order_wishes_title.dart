import 'package:flutter/material.dart';

class OrderWishesTitle extends StatelessWidget {
  final String title;

  const OrderWishesTitle(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 4,
        ),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 30,
        ),
        SizedBox(
          width: 16,
        ),
        Flexible(
          child: Text(
            title,
            // textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ],
    );
  }
}
