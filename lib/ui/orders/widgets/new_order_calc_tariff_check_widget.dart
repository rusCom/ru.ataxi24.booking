import 'package:booking/models/main_application.dart';
import 'package:booking/models/order_tariff.dart';
import 'package:flutter/material.dart';

import 'new_order_calc_tariff_widget.dart';

class NewOrderCalcTariffCheckWidget extends StatelessWidget {
  OrderTariff getOrderTariff(String type) {
    OrderTariff result;
    MainApplication().curOrder.orderTariffs.forEach((orderTariff) {
      if (orderTariff.type == type) {
        result = orderTariff;
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 0, top: 3, right: 8),
      child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getOrderTariff("econom") == null ? Container() : NewOrderCalcTariffWidget(getOrderTariff("econom")),
                getOrderTariff("comfort") == null ? Container() : NewOrderCalcTariffWidget(getOrderTariff("comfort")),
                getOrderTariff("comfort_plus") == null ? Container() : NewOrderCalcTariffWidget(getOrderTariff("comfort_plus")),
                getOrderTariff("buisness") == null ? Container() : NewOrderCalcTariffWidget(getOrderTariff("buisness")),
                getOrderTariff("cargo") == null ? Container() : NewOrderCalcTariffWidget(getOrderTariff("cargo")),
              ],
            ),
          )),
    );
  }
}
