import 'package:booking/models/agent.dart';
import 'package:booking/models/main_application.dart';
import 'package:booking/models/order_tariff.dart';
import 'package:booking/models/payment_type.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum OrderState {
  new_order,
  new_order_calculating,
  new_order_calculated,
  search_car,
  drive_to_client,
  drive_at_client,
  paid_idle,
  client_in_car,
}

class Order {
  final String TAG = (Order).toString(); // ignore: non_constant_identifier_names
  OrderState _orderState;
  String _uid;
  List<RoutePoint> routePoints = [];
  String _lastRoutePoints = "";
  String dispatcherPhone = "";
  Agent agent; // водитель
  List<PaymentType> paymentTypes = []; // типы платежей и тарифы
  String cost, _payType = "";
  DateTime _workDate;

  String getLastRouteName() {
    if (routePoints.length == 1)
      return "";
    else if (routePoints.length == 2)
      return routePoints.last.name;
    else if (routePoints.length == 3)
      return routePoints[1].name + " -> " + routePoints.last.name;
    else
      return "Еще " + (routePoints.length - 1).toString() + " адреса";
  }

  String getLastRouteDsc() {
    if (routePoints.length == 2) return routePoints.last.dsc;
    return "";
  }

  void deleteRoutePoint(Key item) {
    routePoints.removeAt(_indexRoutePointOfKey(item));
    AppBlocs().orderRoutePointsController.sink.add(routePoints);
    MapMarkersService().refresh();
  }

  bool reorderRoutePoints(Key item, Key newPosition) {
    int draggingIndex = _indexRoutePointOfKey(item);
    int newPositionIndex = _indexRoutePointOfKey(newPosition);
    final draggedItem = routePoints[draggingIndex];
    routePoints.removeAt(draggingIndex);
    routePoints.insert(newPositionIndex, draggedItem);
    routePoints.first.checkPickUp();
    AppBlocs().orderRoutePointsController.sink.add(routePoints);
    MapMarkersService().refresh();
    return true;
  }

  List<OrderTariff> get orderTariffs {
    if (_orderState == OrderState.new_order_calculating) {
      return routePoints.first.orderTariffs;
    }

    PaymentType result;
    paymentTypes.forEach((paymentType) {
      if (paymentType.checked) result = paymentType;
    });
    if (result == null) return [];
    return result.orderTariffs;
  }

  int _indexRoutePointOfKey(Key key) {
    return routePoints.indexWhere((RoutePoint d) => d.key == key);
  }

  void addRoutePoint(RoutePoint routePoint, {bool isLast = false}) {
    if (isLast) {
      routePoints.last = routePoint;
    } else {
      routePoints.add(routePoint);
    }

    if (routePoints.length > 1) {
      if (orderState == OrderState.new_order) {
        calcOrder();
      }
      if (orderState == OrderState.new_order_calculated) {
        calcOrder();
      }
      MapMarkersService().refresh();
    }
    AppBlocs().orderRoutePointsController.sink.add(routePoints);
  }


  set workDate(DateTime value) {
    if (_workDate != value){
      _workDate = value;
      calcOrder();
    }
  }



  set orderState(OrderState value) {
    if (_orderState != value) {
      DebugPrint().log(TAG, "orderState", "new order state = " + value.toString());

      bool startTimer = false;
      _orderState = value;

      switch (_orderState) {
        case OrderState.new_order:
          _workDate = null;
          startTimer = false;
          moveToCurLocation();
          routePoints.clear();
          break;
        case OrderState.new_order_calculating:
          startTimer = false;
          AppBlocs().newOrderTariffController.sink.add(orderTariffs);
          break;
        case OrderState.new_order_calculated:
          startTimer = false;
          AppBlocs().newOrderTariffController.sink.add(orderTariffs);
          break;
        case OrderState.search_car:
          animateCamera();
          startTimer = true;
          break;
        case OrderState.drive_to_client:
          animateCamera();
          MainApplication.audioCache.play(MainApplication.audioAlarmOrderStateChange);
          startTimer = true;
          break;
        case OrderState.drive_at_client:
          animateCamera();
          MainApplication.audioCache.play(MainApplication.audioAlarmOrderStateChange);
          startTimer = true;
          break;
        case OrderState.paid_idle:
          animateCamera();
          MainApplication.audioCache.play(MainApplication.audioAlarmOrderStateChange);
          startTimer = true;
          break;
        case OrderState.client_in_car:
          animateCamera();
          MainApplication.audioCache.play(MainApplication.audioAlarmOrderStateChange);
          startTimer = true;
          break;
      }

      MainApplication().dataCycle = startTimer;

      AppBlocs().orderStateController.sink.add(_orderState);
    } // if (_orderState != value)
  }

  Future<void> calcOrder() async {
    DebugPrint().log(TAG, "calcOrder", this.toString());
    orderState = OrderState.new_order_calculating;

    String checkPayment = checkedPayment;
    String checkTariff = checkedTariff;

    var response = await RestService().httpPost("/orders/calc", toJson());
    if (response["status"] == "OK") {
      var result = response["result"];
      _uid = result['uid'];

      Iterable payments = result["payments"];
      paymentTypes = payments.map((model) => PaymentType.fromJson(model)).toList();

      orderState = OrderState.new_order_calculated;
      checkedPayment = checkPayment;
      checkedTariff = checkTariff;
      DebugPrint().log(TAG, "calcOrder", this.toString());
    }
  }

  PaymentType getPaymentType(String type) {
    PaymentType result;
    paymentTypes.forEach((paymentType) {
      if (paymentType.type == type) result = paymentType;
    });
    return result;
  }

  bool isPaymentType(String type) {
    bool res = false;
    paymentTypes.forEach((paymentType) {
      if (paymentType.type == type) res = true;
    });
    return res;
  }


  DateTime get workDate => _workDate;

  PaymentType get paymentType {
    if (_payType != "") return PaymentType(type: _payType);
    PaymentType result;
    paymentTypes.forEach((paymentType) {
      if (paymentType.checked) result = paymentType;
    });
    if (result == null) {
      return PaymentType(type: "cash");
    }
    return result;
  }

  String get checkedPayment {
    String result = "cash";
    paymentTypes.forEach((paymentType) {
      if (paymentType.checked) result = paymentType.type;
    });
    return result;
  }

  set checkedPayment(String type) {
    String checkTariff = checkedTariff;
    paymentTypes.forEach((paymentType) {
      if (paymentType.type == type)
        paymentType.checked = true;
      else
        paymentType.checked = false;
    });
    checkedTariff = checkTariff;
    AppBlocs().newOrderPaymentController.sink.add(checkTariff);
  }

  set checkedTariff(String type) {
    orderTariffs.forEach((orderTariff) {
      if (orderTariff.type == type)
        orderTariff.checked = true;
      else
        orderTariff.checked = false;
    });
    AppBlocs().newOrderTariffController.sink.add(orderTariffs);
  }

  String get checkedTariff {
    String result = "econom";
    if (orderTariffs == null) {
      return result;
    }
    orderTariffs.forEach((orderTariff) {
      if (orderTariff.checked) result = orderTariff.type;
    });
    return result;
  }

  OrderState get orderState => _orderState;

  Map<String, dynamic> toJson() => {
        "uid": _uid,
        "dispatcher_phone": dispatcherPhone,
        "tariff": checkedTariff,
        "payment": checkedPayment,
        "work_date": workDate != null ? workDate.toString() : "",
        "state": orderState.toString(),
        "agent": agent,
        "route": routePoints,
        "payments": paymentTypes,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  void parseData(Map<String, dynamic> jsonData) {
    DebugPrint().log(TAG, "parseData", jsonData.toString());
    _uid = jsonData['uid'];
    dispatcherPhone = jsonData['dispatcher_phone'];
    cost = jsonData['cost'] != null ? jsonData['cost'] : "";
    _payType = jsonData['payment'] != null ? jsonData['payment'] : "";

    switch (jsonData['state']) {
      case "search_car":
        orderState = OrderState.search_car;
        break;
      case "drive_to_client":
        orderState = OrderState.drive_to_client;
        break;
      case "drive_at_client":
        orderState = OrderState.drive_at_client;
        break;
      case "paid_idle":
        orderState = OrderState.paid_idle;
        break;
      case "client_in_car":
        orderState = OrderState.client_in_car;
        break;

      default:
        orderState = OrderState.new_order;
        break;
    }
    if (jsonData.containsKey("agent")) {
      agent = Agent.fromJson(jsonData['agent']);
      MapMarkersService().agentMarkerRefresh();
    } else {
      agent = null;
      MapMarkersService().clearAgentMarker();
    }

    if (jsonData.containsKey("route")) {
      if (_lastRoutePoints != jsonData['route'].toString()) {
        // если есть изменения по точкам маршрута
        Iterable list = jsonData['route'];
        routePoints = list.map((model) => RoutePoint.fromJson(model)).toList();
        MapMarkersService().refresh();
        if (animateCamera()) {
          _lastRoutePoints = jsonData['route'].toString();
        }
      } // if (_lastRoutePoints != jsonData['route'].toString()){
    }
    DebugPrint().log(TAG, "parseData", this.toString());
  }

  bool animateCamera() {
    if (MainApplication().mapController != null) {
      MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), 50));
      return true;
    }
    return false;
  }

  bool get mapBoundsIcon {
    switch (orderState) {
      case OrderState.drive_to_client:
        return true;
      case OrderState.drive_at_client:
        return true;
      case OrderState.paid_idle:
        return true;
      case OrderState.client_in_car:
        return true;
      default:
        return false;
    }
  }

  deny(String reason) async {
    Map<String, dynamic> restResult = await RestService().httpGet("/orders/deny?uid=" + _uid + "&reason=" + Uri.encodeFull(reason));
    MainApplication().parseData(restResult['result']);
  }

  add() async {
    Map<String, dynamic> restResult = await RestService().httpPost("/orders/add", toJson());
    MainApplication().parseData(restResult['result']);
  }

  void moveToCurLocation() {
    LatLng curLocation = MainApplication().currentLocation;
    if (curLocation != null) {
      if (MainApplication().mapController != null) {
        MainApplication().mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: curLocation,
                  zoom: 17.0,
                ),
              ),
            );
      }
    }
  }
}
