import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/order_tariff.dart';
import 'package:flutter/material.dart';

class NewOrderCalcTariffWidget extends StatelessWidget {
  final OrderTariff orderTariff;

  NewOrderCalcTariffWidget(this.orderTariff);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 1),
        child: RaisedButton(
          onPressed: () => MainApplication().curOrder.checkedTariff = orderTariff.type,
          shape: orderTariff.checked == true
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.amber, width: 2),
                )
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
          padding: EdgeInsets.only(right: 8),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  orderTariff.iconName,
                  width: 70,
                ),
                Text(orderTariff.name),
                MainApplication().curOrder.orderState == OrderState.new_order_calculating
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.cyan,
                          strokeWidth: 2.0,
                        ),
                      )
                    : SizedBox(
                        height: 18,
                        width: 70,
                        child: Text(
                          orderTariff.price + " \u20BD",
                          textAlign: TextAlign.center,
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
