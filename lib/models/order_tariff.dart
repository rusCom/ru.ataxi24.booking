class OrderTariff{
  String type;
  String price;
  bool checked;


  OrderTariff({this.type, this.price}){
    checked = false;
  }

  factory OrderTariff.fromJson(Map<String, dynamic> json) {
    return OrderTariff(
      type: json['type'] != null ? json['type'] : "",
      price: json['price'] != null ? json['price'].toString() : "",
    );
  }


  String get name {
    switch (type){
      case "econom": return "Эконом";
      case "comfort": return "Комфорт";
      case "comfort_plus": return "Комфорт+";
      case "business": return "Бизнес";
      case "delivery": return "Доставка";
      case "sober_driver": return "Перегон";
      case "cargo": return "Грузовой";
      case "express": return "Экспресс";
    }
    return "Эконом";

  }

  String get iconName{
    switch (type){
      case "econom": return "assets/icons/ic_tariff_econom.png";
      case "comfort": return "assets/icons/ic_tariff_comfort.png";
      case "comfort_plus": return "assets/icons/ic_tariff_comfort_plus.png";
      case "business": return "assets/icons/ic_tariff_business.png";
      case "delivery": return "assets/icons/ic_tariff_delivery.png";
      case "sober_driver": return "assets/icons/ic_tariff_sober_driver.png";
      case "cargo": return "assets/icons/ic_tariff_cargo.png";
      case "express": return "assets/icons/ic_tariff_express.png";

    }
    return "assets/icons/ic_tariff_econom.png";
  }

  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'name': name,
        'price': price,
        'checked': checked
      };

  @override
  String toString() {
    return toJson().toString();
  }
}