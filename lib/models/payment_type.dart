import 'package:booking/models/main_application.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'order_tariff.dart';

class PaymentType {
  final String type;
  String name;
  String choseName;
  String iconName;
  String choseIconName;
  Icon icon;
  bool isChosen;
  bool checked;
  List<OrderTariff> orderTariffs = [];

  PaymentType({this.type, this.orderTariffs}) {
    switch (type) {
      case "cash":
        name = "Наличные";
        choseName = "Наличный расчет";
        iconName = "assets/icons/ic_payment_cash.png";
        break;
      case "corporation":
        name = "Организация";
        choseName = "За счет организации";
        iconName = "assets/icons/ic_payment_corporation.png";
        break;
      case "sberbank":
        name = "Сбербанк";
        choseName = "Сбербанк Онлайн перевод водителю";
        iconName = "assets/icons/ic_payment_sberbank.png";
        break;
      case "bonuses":
        name = "Бонусы";
        choseName = "Оплата бонусами";
        iconName = "assets/icons/ic_payment_bonus.png";
        break;
    }
    checked = false;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaymentType && runtimeType == other.runtimeType && type == other.type;

  @override
  int get hashCode => type.hashCode;

  factory PaymentType.fromJson(Map<String, dynamic> jsonData) {
    if (DebugPrint().orderCalcDebugPrint){
      // Logger().d(jsonData['tariffs']);
    }

    List<OrderTariff> orderTariffs = [];
    if (jsonData.containsKey('tariffs')){
      Iterable list = jsonData["tariffs"];
      orderTariffs = list.map((model) => OrderTariff.fromJson(model)).toList();
    }

    return PaymentType(
      type: jsonData['type'] != null ? jsonData['type'] : "",
      orderTariffs: orderTariffs,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "tariffs": orderTariffs.toString(),

      };

  @override
  String toString() {
    return toJson().toString();
  }
}
