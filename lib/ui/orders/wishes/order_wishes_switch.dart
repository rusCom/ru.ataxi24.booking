import 'package:flutter/material.dart';

typedef void OrderWishesSwitchChangeCallback(bool value);

class OrderWishesSwitch extends StatefulWidget {
  final bool orderWishesValue;
  final bool viewSwitch;
  final String caption;
  final OrderWishesSwitchChangeCallback onChanged;

  const OrderWishesSwitch({Key key, this.orderWishesValue, this.caption, this.onChanged, this.viewSwitch = true}) : super(key: key);

  @override
  _OrderWishesSwitchState createState() => _OrderWishesSwitchState();
}

class _OrderWishesSwitchState extends State<OrderWishesSwitch> {
  bool orderWishesValue;

  @override
  Widget build(BuildContext context) {
    if (!widget.viewSwitch) return Container();
    if (orderWishesValue == null) {
      orderWishesValue = widget.orderWishesValue;
    }
    return ListTile(
      title: Text(widget.caption),
      trailing: Switch(
        value: orderWishesValue,
        onChanged: (value) => setState(() {
          orderWishesValue = value;
          if (widget.onChanged != null) widget.onChanged(value);
        }),
      ),
    );
  }
}
