import 'package:booking/models/order_tariff.dart';
import 'package:booking/models/payment_type.dart';
import 'package:booking/ui/utils/core.dart';

class Preferences{
  final String TAG = (Preferences).toString(); // ignore: non_constant_identifier_names
  static final Preferences _singleton = Preferences._internal();
  factory Preferences() => _singleton;
  Preferences._internal();

  String administrationPhone;
  String googleKey = "";
  int timerTask;
  bool mapAdmin = false;
  List<PaymentType> paymentTypes = [];
  List<OrderTariff> orderTariffs = [];
  bool geocodeMove = false;


  void parseData(Map<String, dynamic> jsonData){
    DebugPrint().log(TAG, "parseData", jsonData);

    administrationPhone = jsonData['administration_phone'] != null ? jsonData['administration_phone'] : "";
    googleKey           = jsonData['google_key'] != null ? jsonData['google_key'] : "";
    timerTask           = jsonData['timer'] != null ? int.parse(jsonData['timer']) : 5;
    mapAdmin            = jsonData['map_admin'] != null ? jsonData['map_admin'].toLowerCase() == 'true'  : false;
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