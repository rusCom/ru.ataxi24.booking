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
  bool mapDirections = false;
  List<PaymentType> paymentTypes = [];
  List<OrderTariff> orderTariffs = [];
  bool geocodeMove = false;

  bool systemMapAdmin = false;
  double systemMapBounds = 35.0;
  int systemHttpTimeOut = 10;
  int systemTimerTask = 5;


  void parseData(Map<String, dynamic> jsonData){
    DebugPrint().log(TAG, "parseData", jsonData);

    administrationPhone = jsonData['administration_phone'] != null ? jsonData['administration_phone'] : "";
    googleKey           = jsonData['google_key'] != null ? jsonData['google_key'] : "";


    if (jsonData['system'] != null){
      systemMapAdmin    = MainUtils.parseBool(jsonData['system']['map_admin']);
      mapDirections     = MainUtils.parseBool(jsonData['system']['map_directions']);
      systemHttpTimeOut = MainUtils.parseInt(jsonData['system']['http_timeout'], def: 20);
      systemTimerTask   = MainUtils.parseInt(jsonData['system']['timer_task'], def: 5);

    }

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