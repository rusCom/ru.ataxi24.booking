class OrderTariff{
  String type;
  String _name;
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
      case "buisness": return "Бизнес";
      case "cargo": return "Грузовой";
    }
    return "Эконом";

  }

  String get iconName{
    switch (type){
      case "econom": return "assets/icons/ic_tariff_econom.png";
      case "comfort": return "assets/icons/ic_tariff_comfort.png";
      case "buisness": return "assets/icons/ic_tariff_business.png";
      case "cargo": return "assets/icons/ic_tariff_cargo.jfif";
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