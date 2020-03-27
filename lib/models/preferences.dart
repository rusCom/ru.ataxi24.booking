import 'package:booking/models/order_tariff.dart';
import 'package:booking/models/payment_type.dart';

class Preferences{
  String administrationPhone;
  int timerTask;
  List<PaymentType> paymentTypes = [];
  List<OrderTariff> orderTariffs = [];


  Preferences();

  void parseData(Map<String, dynamic> jsonData){
    administrationPhone = jsonData['administration_phone'] != null ? jsonData['administration_phone'] : "";
    timerTask           = jsonData['timer'] != null ? int.parse(jsonData['timer']) : 5;
    if (jsonData.containsKey('payments')){
      paymentTypes = [];
      List<String> payments = jsonData['payments'].cast<String>();
      payments.forEach((payment) => paymentTypes.add(PaymentType(type: payment)));
    }
    if (jsonData.containsKey('tariffs')){
      orderTariffs = [];
      List<String> tariffs = jsonData['tariffs'].cast<String>();
      tariffs.forEach((tariff) => orderTariffs.add(OrderTariff(type: tariff)));
    }
  }
  
  PaymentType paymentType(String type){
    paymentTypes.forEach((paymentType)  {
      if (paymentType.type == type){
        return paymentType;
      }
      return PaymentType(type: "cash");
    });
    return PaymentType(type: "cash");
  }
  
  Map<String, dynamic> toJson() => {
    "administrationPhone": administrationPhone,
    "paymentTypes": paymentTypes,
    "orderTariffs": orderTariffs,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}