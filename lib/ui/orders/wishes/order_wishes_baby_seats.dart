import 'package:booking/models/main_application.dart';
import 'package:booking/models/order_baby_seats.dart';
import 'package:booking/ui/orders/wishes/order_wishes_title.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:booking/ui/widgets/number_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef void OrderWishesBabySeatsChangeCallback(OrderBabySeats value);

class OrderWishesBabySeats extends StatefulWidget {
  final OrderBabySeats orderBabySeats;
  final OrderWishesBabySeatsChangeCallback onChanged;

  const OrderWishesBabySeats({Key key, this.orderBabySeats, this.onChanged}) : super(key: key);

  @override
  _OrderWishesBabySeatsState createState() => _OrderWishesBabySeatsState();
}

class _OrderWishesBabySeatsState extends State<OrderWishesBabySeats> {
  OrderBabySeats orderBabySeats;

  @override
  Widget build(BuildContext context) {
    if (!MainApplication().curOrder.orderTariff.wishesBabySeats) return Container();
    if (orderBabySeats == null) {
      orderBabySeats = widget.orderBabySeats;
    }
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_baby_seats.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: Text("Детское кресло"),
      trailing: IconButton(
        icon: Icon(orderBabySeats.isClearButton ? Icons.clear : Icons.keyboard_arrow_right),
        onPressed: () async {
          if (orderBabySeats.isClearButton) {
            setState(() {
              orderBabySeats.clear();
              if (widget.onChanged != null) {
                widget.onChanged(orderBabySeats);
              }
            });
          } else {
            OrderBabySeats newOrderBabySeats = await orderWishesBabySeats(context, orderBabySeats);
            setState(() {
              orderBabySeats = newOrderBabySeats;
              if (widget.onChanged != null) {
                widget.onChanged(newOrderBabySeats);
              }
            });
          }
        },
      ),
      subtitle: orderBabySeats.subtitle,
      onTap: () async {
        OrderBabySeats newOrderBabySeats = await orderWishesBabySeats(context, orderBabySeats);
        setState(() {
          orderBabySeats = newOrderBabySeats;
          if (widget.onChanged != null) {
            widget.onChanged(newOrderBabySeats);
          }
        });
      },
    );
  }

  Future<OrderBabySeats> orderWishesBabySeats(BuildContext context, OrderBabySeats inOrderBabySeats) async {
    OrderBabySeats orderBabySeats = inOrderBabySeats;
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
              child: Column(
                children: <Widget>[
                  OrderWishesTitle("Детское кресло"),
                  ListTile(
                    title: Text("Люлька"),
                    subtitle: Text("до 10 кг"),
                    trailing: NumberCounter(
                      initialValue: orderBabySeats.babySeat0010,
                      minValue: 0,
                      maxValue: 2,
                      color: Colors.amber,
                      onChanged: (value) => stateSetter(() => orderBabySeats.babySeat0010 = value),
                    ),
                  ),
                  ListTile(
                    title: Text("Кресло"),
                    subtitle: Text("от 9 до 18 кг"),
                    trailing: NumberCounter(
                      initialValue: orderBabySeats.babySeat0918,
                      minValue: 0,
                      maxValue: 2,
                      color: Colors.amber,
                      onChanged: (value) => stateSetter(() => orderBabySeats.babySeat0918 = value),
                    ),
                  ),
                  ListTile(
                    title: Text("Кресло"),
                    subtitle: Text("от 15 до 25 кг"),
                    trailing: NumberCounter(
                      initialValue: orderBabySeats.babySeat1525,
                      minValue: 0,
                      maxValue: 2,
                      color: Colors.amber,
                      onChanged: (value) => stateSetter(() => orderBabySeats.babySeat1525 = value),
                    ),
                  ),
                  ListTile(
                    title: Text("Бустер"),
                    subtitle: Text("от 22 до 36 кг"),
                    trailing: NumberCounter(
                      initialValue: orderBabySeats.babySeat2236,
                      minValue: 0,
                      maxValue: 2,
                      color: Colors.amber,
                      onChanged: (value) => stateSetter(() => orderBabySeats.babySeat2236 = value),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return orderBabySeats;
  }
}
