import 'package:booking/models/order_tariff.dart';
import 'package:booking/models/payment_type.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:flutter/material.dart';

enum OrderState {
  new_order,
  new_order_calculating,
  new_order_calculated,
  search_car,
}

class Order {
  OrderState _orderState;
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

  void checkTariff(String type) {
    orderTariffs.asMap().forEach((index, value) {
      if (value.type == type) {
        orderTariffs[index].checked = true;
      } else {
        orderTariffs[index].checked = false;
      }
    });
    AppBlocs().newOrderTariffController.sink.add(orderTariffs);
  }

  Future<void> calcOrder() async {
    var response = await RestService().httpGet("/orders/calc");
    if (response["status"] == "OK"){
      var result = response["result"];
      Iterable list = result["tariffs"];
      orderTariffs = list.map((model) => OrderTariff.fromJson(model)).toList();
      orderTariffs.first.checked = true;
      orderState = OrderState.new_order_calculated;
    }


  }

  OrderState get orderState => _orderState;

  Map<String, dynamic> toJson() => {
        "route": routePoints,
        "state": orderState,
      };
}
