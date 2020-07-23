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
import 'package:logger/logger.dart';

enum OrderState {
  new_order,
  new_order_calculating,
  new_order_calculated,
  search_car,
  carried_out,
}

class Order {
  OrderState _orderState;
  String _guid;
  List<RoutePoint> routePoints = [];
  String _lastRoutePoints = "";
  Agent agent; // водитель
  List<PaymentType> paymentTypes = []; // типы платежей и тарифы

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
        orderState = OrderState.new_order_calculating;
      }
      if (orderState == OrderState.new_order_calculated) {
        orderState = OrderState.new_order_calculating;
      }
      MapMarkersService().refresh();
    }
    AppBlocs().orderRoutePointsController.sink.add(routePoints);
  }

  set orderState(OrderState value) {
    if (_orderState != value) {
      bool startTimer = false;
      _orderState = value;
      if (value == OrderState.new_order) {
        routePoints.clear();
        // paymentType = "cash";
      }

      if (value == OrderState.new_order_calculating) {
        AppBlocs().newOrderTariffController.sink.add(orderTariffs);
        calcOrder();
      }

      if (value == OrderState.new_order_calculated) {
        AppBlocs().newOrderTariffController.sink.add(orderTariffs);
      }

      if (value == OrderState.carried_out) {
        // Logger().d("Статус заказа поиск авто. Запускаем таймер");
        startTimer = true;
      }

      MainApplication().dataCycle = startTimer;

      AppBlocs().orderStateController.sink.add(_orderState);
    }
  }

  Future<void> calcOrder() async {
    if (DebugPrint().orderCalcDebugPrint) {
      Logger().d(toString());
    }

    String checkPayment = checkedPayment;
    String checkTariff = checkedTariff;

    var response = await RestService().httpPost("/orders/calc", toJson());
    if (response["status"] == "OK") {
      var result = response["result"];
      _guid = result['guid'];

      Iterable payments = result["payments"];
      paymentTypes = payments.map((model) => PaymentType.fromJson(model)).toList();

      orderState = OrderState.new_order_calculated;
      checkedPayment = checkPayment;
      checkedTariff = checkTariff;
      if (DebugPrint().orderCalcDebugPrint) {
        Logger().d(toString());
      }
    }
  }

  PaymentType getPaymentType(String type) {
    PaymentType result;
    paymentTypes.forEach((paymentType) {
      if (paymentType.type == type) result = paymentType;
    });
    return result;
  }

  bool isPaymentType(String type){
    bool res = false;
    paymentTypes.forEach((paymentType) {
      if (paymentType.type == type) res = true;
    });
    return res;
  }

  PaymentType get paymentType {
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
    orderTariffs.forEach((orderTariff) {
      if (orderTariff.checked) result = orderTariff.type;
    });
    return result;
  }

  OrderState get orderState => _orderState;

  Map<String, dynamic> toJson() => {
        "guid": _guid,
        "tariff": checkedTariff,
        "payment": checkedPayment,
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
    // Logger().d(jsonData.toString());
    switch (jsonData['state']) {
      case "client_in_car":
        orderState = OrderState.carried_out;
        break;
      default:
        orderState = OrderState.new_order;
        break;
    }
    if (jsonData.containsKey("agent")) {
      agent = Agent.fromJson(jsonData['agent']);
      MapMarkersService().agentMarkerRefresh();
    }

    if (jsonData.containsKey("route")) {
      if (_lastRoutePoints != jsonData['route'].toString()) {
        // если есть изменения по точкам маршрута
        Iterable list = jsonData['route'];
        routePoints = list.map((model) => RoutePoint.fromJson(model)).toList();
        MapMarkersService().refresh();
        if (MainApplication().mapController != null) {
          MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), 50));
          _lastRoutePoints = jsonData['route'].toString();
        }
      } // if (_lastRoutePoints != jsonData['route'].toString()){
    }
    Logger().d(this.toString());
  }

  bool get mapBoundsIcon {
    switch (orderState) {
      case OrderState.carried_out:
        return true;

      default:
        return false;
    }
  }
}
