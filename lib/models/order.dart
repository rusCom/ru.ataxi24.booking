import 'package:booking/models/order_tariff.dart';
import 'package:booking/models/payment_type.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum OrderState {
  new_order,
  new_order_calculating,
  new_order_calculated,
  search_car,
}

class Order {
  OrderState _orderState;
  String _guid;
  List<RoutePoint> routePoints = [];
  List<OrderTariff> orderTariffs = [];
  List<PaymentType> paymentTypes = [];

  String getLastRouteName(){
    if (routePoints.length == 1)return "";
    else if (routePoints.length == 2)return routePoints.last.name;
    else if (routePoints.length == 3)return routePoints[1].name + " -> " + routePoints.last.name;
    else return "Еще " + (routePoints.length - 1).toString() + " адреса";

  }

  void deleteRoutePoint(Key item){
    routePoints.removeAt(_indexRoutePointOfKey(item));
    AppBlocs().orderRoutePointsController.sink.add(routePoints);
    MapMarkersService().refresh();
  }

  bool reorderRoutePoints(Key item, Key newPosition){
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

  int _indexRoutePointOfKey(Key key) {
    return routePoints.indexWhere((RoutePoint d) => d.key == key);
  }

  void addRoutePoint(RoutePoint routePoint) {
    routePoints.add(routePoint);
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
      _orderState = value;
      if (value == OrderState.new_order) {
        routePoints.clear();
      }

      if (value == OrderState.new_order_calculating) {
        orderTariffs = routePoints.first.orderTariffs;
        AppBlocs().newOrderTariffController.sink.add(orderTariffs);
        calcOrder();
        print(toJson());
      }

      if (value == OrderState.new_order_calculated) {
        AppBlocs().newOrderTariffController.sink.add(orderTariffs);
        print(toJson());
      }

      AppBlocs().orderStateController.sink.add(_orderState);
    }
  }

  Future<void> calcOrder() async {
    Logger().d(toString());
    String checkTariff = checkedTariff;
    var response = await RestService().httpPost("/orders/calc", toJson());
    if (response["status"] == "OK"){
      var result = response["result"];
      _guid = result['guid'];
      Iterable list = result["tariffs"];
      orderTariffs = list.map((model) => OrderTariff.fromJson(model)).toList();
      orderState = OrderState.new_order_calculated;
      checkedTariff = checkTariff;
      Logger().d(toString());
    }
  }

  set checkedTariff(String type){
    orderTariffs.forEach((orderTariff) {
      if (orderTariff.type == type)orderTariff.checked = true;
      else orderTariff.checked = false;
    });
    AppBlocs().newOrderTariffController.sink.add(orderTariffs);
  }

  String get checkedTariff{
    String result = "econom";
    orderTariffs.forEach((orderTariff) {
      if (orderTariff.checked)result = orderTariff.type;
    });
    return result;
  }

  OrderState get orderState => _orderState;

  Map<String, dynamic> toJson() => {
        "route": routePoints,
        "tariffs":orderTariffs,
        "tariff":checkedTariff,
        "state": orderState.toString(),
      };
  @override
  String toString() {
    return toJson().toString();
  }
}
