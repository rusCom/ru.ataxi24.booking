import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef void OrderWishesSwitchChangeCallback(bool value);

class OrderWishesSwitch extends StatefulWidget {
  final bool orderWishesValue;
  final bool viewSwitch;
  final String caption;
  final String svgAssets;
  final OrderWishesSwitchChangeCallback onChanged;

  const OrderWishesSwitch({Key key, this.orderWishesValue, this.caption, this.onChanged, this.viewSwitch = true, this.svgAssets}) : super(key: key);

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
    if (widget.svgAssets != null) {
      return ListTile(
        leading: CircleAvatar(
          child: SvgPicture.asset(widget.svgAssets),
          backgroundColor: Colors.transparent,
        ),
        title: Text(widget.caption),
        trailing: _switch(),
        onTap: () => setState(() {
          orderWishesValue = !orderWishesValue;
          if (widget.onChanged != null) widget.onChanged(orderWishesValue);
        }),
      );
    }
    return ListTile(
      title: Text(widget.caption),
      trailing: _switch(),
    );
  }

  Widget _switch() {
    return Switch(
        value: orderWishesValue,
        activeColor: Colors.amberAccent,
        onChanged: (value) => setState(() {
              orderWishesValue = value;
              if (widget.onChanged != null) widget.onChanged(value);
            }));
  }
}
