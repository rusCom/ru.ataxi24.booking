import 'package:booking/models/main_application.dart';
import 'package:flutter/material.dart';

class PaymentType {
  final String type;
  String name;
  String choseName;
  String iconName;
  String choseIconName;
  Icon icon;
  bool isChosen;

  PaymentType({this.type}) {
    switch (type) {
      case "cash":
        name = "Наличные";
        choseName = "Наличный расчет";
        iconName = "assets/icons/ic_payment_cash.png";
        choseIconName = "assets/icons/ic_payment_cash_choose.png";
        break;
      case "corporation":
        name = "Организация";
        choseName = "За счет организации";
        iconName = "assets/icons/ic_payment_corporation.png";
        choseIconName = "assets/icons/ic_payment_corporation_choose.png";
        break;
      case "sberbank":
        name = "Сбербанк";
        choseName = "Сбербанк Онлайн перевод водителю";
        iconName = "assets/icons/ic_payment_sberbank.png";
        choseIconName = "assets/icons/ic_payment_sberbank_choose.png";
        break;
    }
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaymentType &&
              runtimeType == other.runtimeType &&
              type == other.type;

  @override
  int get hashCode => type.hashCode;

  factory PaymentType.fromJson(Map<String, dynamic> jsonData) {
    // print("RoutePoint.fromJson json = " + jsonData.toString());
    return PaymentType(
      type: jsonData['type'] != null ? jsonData['type'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
  };
  @override
  String toString() {
    return toJson().toString();
  }
}
