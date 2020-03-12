import 'package:booking/main_application.dart';

class PaymentType {
  final String type;
  String name;
  String choseName;
  String iconName;
  String choseIconName;
  bool isChosen;

  PaymentType({this.type}) {
    switch (type) {
      case "cache":
        name = "Наличные";
        choseIconName = "Наличный расчет";
        iconName = "assets/icons/ic_payment_cash.png";
        choseIconName = "assets/icons/ic_payment_cash_choose.png";
        break;
      case "corporation":
        name = "Организация";
        choseIconName = "За счет организации";
        iconName = "assets/icons/ic_payment_corporation.png";
        choseIconName = "assets/icons/ic_payment_corporation_choose.png";
        break;
      case "credit_card":
        switch (MainApplication().targetPlatform) {
          case "android":
            name = "Google Pay";
            choseIconName = "Google Pay";
            iconName = "assets/icons/ic_payment_google.png";
            choseIconName = "assets/icons/ic_payment_google_choose.png";
            break;
          case "iOS":
            name = "Apple Pay";
            choseIconName = "Apple Pay Pay";
            iconName = "assets/icons/ic_payment_apple.png";
            choseIconName = "assets/icons/ic_payment_apple_choose.png";
            break;
        }
        break;
      case "sberbank":
        name = "Сбербанк";
        choseIconName = "Сбербанк Онлайн перевод водителю";
        iconName = "assets/icons/ic_payment_sberbank.png";
        choseIconName = "assets/icons/ic_payment_sberbank_choose.png";
        break;
      case "bonus":
        name = "Бонусы";
        choseIconName = "За счет накопленный бонусов";
        iconName = "assets/icons/ic_payment_bonus.png";
        choseIconName = "assets/icons/ic_payment_sberbank_bonus.png";
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
}
