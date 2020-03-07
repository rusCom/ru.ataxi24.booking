import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/app_state.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum OrderState{
  new_order,
  new_order_calc,
  search_car
}

class Order{
  OrderState _orderState;
  List<RoutePoint> routePoints = [];

  void addRoutePoint(RoutePoint routePoint){
    routePoints.add(routePoint);
    if (orderState == OrderState.new_order){
      orderState = OrderState.new_order_calc;
    }
    print ("addRoutePoint routes = " + routePoint.toString());
    print ("addRoutePoint routes = " + routePoints.toString());

    MapMarkersProvider().refresh();
  }

  set orderState(OrderState value) {
    _orderState = value;
    AppBlocs().orderStateController.sink.add(_orderState);
    if (value == OrderState.new_order){
      routePoints.clear();
    }
  }

  OrderState get orderState => _orderState;

  Map<String, dynamic> toJson() =>
      {
        'route': routePoints
      };


/*

  void addPickUp(RoutePoint routePoint, {bool mapMarkersRefresh = true}){
    routePoints.clear();
    routePoints.add(routePoint);
    if (orderState == OrderState.new_order_calc){
      orderState = OrderState.new_order;
      AppBlocs().orderStateController.sink.add(orderState);
    }
    if (mapMarkersRefresh){
      MapMarkersProvider().refresh();
    }
    print("Order addPickUp routePoint = " + routePoint.toJson().toString());
    print("Order addPickUp routePoint = " + routePoints.first.toJson().toString());
  }

  Future<RoutePoint> geoCodePickUp() async {
    RoutePoint routePoint = await GeoService().geocode(routePoints.first.getLocation());
    addPickUp(routePoint, mapMarkersRefresh: false);
    return routePoint;
  }

  void addPickUpLocation(LatLng location){
    RoutePoint routePoint = new RoutePoint(lt: location.latitude.toString(), ln: location.longitude.toString());
    addPickUp(routePoint);
  }

   */



}