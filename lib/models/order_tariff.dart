class OrderTariff{
  String type;
  String name;
  String price;
  bool checked;


  OrderTariff({this.type, this.name, this.price}){
    checked = false;
  }

  factory OrderTariff.fromJson(Map<String, dynamic> json) {

    return OrderTariff(
      type: json['type'] != null ? json['type'] : "",
      name: json['name'] != null ? json['name'] : "",
      price: json['price'] != null ? json['price'].toString() : "",
    );
  }

  String get iconName{
    switch (type){
      case "econom": return "assets/icons/ic_tariff_standard.png";
      case "comfort": return "assets/icons/ic_tariff_comfort.png";
      case "comfort+": return "assets/icons/ic_tariff_comfort_plus.png";
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
}

var jsonTariffs = [
  {
    "name":"Эконом",
    "type":"econom",
    "price":250
  },
  {
    "name":"Комфорт",
    "type":"comfort",
    "price":350
  },
  {
    "name":"Комфорт+",
    "type":"comfort+",
    "price":450
  },
  {
    "name":"Бизнес",
    "type":"buisness",
    "price":550
  },
  {
    "name":"Грузовой",
    "type":"cargo",
    "price":650
  }
];