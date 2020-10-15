import 'package:booking/models/main_application.dart';

class OrderTariff {
  String type;
  String price;

  OrderTariff({this.type, this.price}) {}

  factory OrderTariff.fromJson(Map<String, dynamic> json) {
    return OrderTariff(
      type: json['type'] != null ? json['type'] : "",
      price: json['price'] != null ? json['price'].toString() : "",
    );
  }

  String get name {
    switch (type) {
      case "econom":
        return "Эконом";
      case "comfort":
        return "Комфорт";

      case "business":
        return "Бизнес";
      case "delivery":
        return "Доставка";
      case "sober_driver":
        return "Перегон";
      case "cargo":
        return "Грузовой";
      case "express":
        return "Экспресс";
    }
    return "Эконом";
  }

  String get iconName {
    switch (type) {
      case "econom":
        return "assets/icons/ic_tariff_econom.png";
      case "comfort":
        return "assets/icons/ic_tariff_comfort.png";
      case "business":
        return "assets/icons/ic_tariff_business.png";
      case "delivery":
        return "assets/icons/ic_tariff_delivery.png";
      case "sober_driver":
        return "assets/icons/ic_tariff_sober_driver.png";
      case "cargo":
        return "assets/icons/ic_tariff_cargo.png";
      case "express":
        return "assets/icons/ic_tariff_express.png";
    }
    return "assets/icons/ic_tariff_econom.png";
  }

  bool get wishesBabySeats {
    switch (type) {
      case "econom":
        return true;
      case "comfort":
        return true;
      case "business":
        return true;
      case "express":
        return true;
    }
    return false;
  }

  bool get wishesPetTransportation {
    switch (type) {
      case "econom":
        return true;
      case "comfort":
        return true;
      case "express":
        return true;
    }
    return false;
  }

  bool get wishesNonSmokingSalon {
    switch (type) {
      case "econom":
        return true;
      case "comfort":
        return true;
      case "express":
        return true;
    }
    return false;
  }

  bool get wishesConditioner {
    switch (type) {
      case "econom":
        return true;
      case "comfort":
        return true;
      case "express":
        return true;
    }
    return false;
  }

  bool get selected {
    if (type == MainApplication().curOrder.selectedOrderTariff)return true;
    return false;
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'price': price,
        'selected': selected,
        "wishesBabySeats": wishesBabySeats,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
