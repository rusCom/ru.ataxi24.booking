import 'package:booking/models/order_tariff.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/services/rest_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class RoutePoint {
  final String name;
  final String dsc;
  final String lt;
  final String ln;
  final String type;
  final String placeId;
  final String detail;
  final List<String> notes;
  Key key;
  String _note = "";
  List<OrderTariff> orderTariffs = [];
  bool canPickUp;

  RoutePoint({this.name, this.dsc, this.lt, this.ln, this.type, this.placeId, this.detail, this.canPickUp, this.orderTariffs, this.notes}) {
    key = ValueKey(Uuid().v1());
    // orderTariffs = List<OrderTariff>;
  }

  factory RoutePoint.fromJson(Map<String, dynamic> jsonData) {
    // print("RoutePoint.fromJson json = " + jsonData.toString());
    return RoutePoint(
      name: jsonData['name'] != null ? jsonData['name'] : "",
      dsc: jsonData['dsc'] != null ? jsonData['dsc'] : "",
      lt: jsonData['lt'] != null ? jsonData['lt'] : "",
      ln: jsonData['ln'] != null ? jsonData['ln'] : "",
      type: jsonData['type'] != null ? jsonData['type'] : "",
      placeId: jsonData['place_id'] != null ? jsonData['place_id'] : "",
      detail: jsonData['detail'] != null ? jsonData['detail'] : "0",
      notes: jsonData['notes'] != null ? jsonData['notes'].cast<String>() : [],
    );
  }

  factory RoutePoint.copy(RoutePoint routePoint) {
    return RoutePoint(
        name: routePoint.name,
        dsc: routePoint.dsc,
        lt: routePoint.lt,
        ln: routePoint.ln,
        type: routePoint.type,
        placeId: routePoint.placeId,
        detail: routePoint.detail,
        canPickUp: routePoint.canPickUp,
        orderTariffs: routePoint.orderTariffs,
        notes: routePoint.notes);
  }

  set note(String value) {
    _note = value;
    // print("RoutePoint set note " + toString());
    AppBlocs().newOrderNoteController.sink.add(_note);
  }

  String get note {
    if (_note == "") {
      return "Подъезд";
    }
    if (_note == null) {
      return "Подъезд";
    }
    return _note;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "dsc": dsc,
        "lt": lt,
        "ln": ln,
        "note": note,
        "notes": notes,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  Future<void> checkPickUp() async {
    if (canPickUp == null) {
      var response = await RestService().httpGet("/orders/pickup?lt=" + lt + "&ln=" + ln);
      if (response['status'] == 'OK') {
        if (response['result']['pick_up'].toString() == "true") {
          orderTariffs = [];
          List<String> tariffs = response['result']['tariffs'].cast<String>();
          tariffs.forEach((tariff) => orderTariffs.add(OrderTariff(type: tariff)));
          canPickUp = true;
          MapMarkersService().pickUpState = PickUpState.enabled;
        } else {
          canPickUp = false;
          MapMarkersService().pickUpState = PickUpState.disabled;
        }
      }
    } else {
      if (canPickUp)
        MapMarkersService().pickUpState = PickUpState.enabled;
      else
        MapMarkersService().pickUpState = PickUpState.disabled;
    }
  }

  LatLng getLocation() {
    return new LatLng(double.parse(lt), double.parse(ln));
  }

  Icon getIcon() {
    switch (type) {
      case 'airport':
        return Icon(Icons.local_airport);
      case 'train_station':
        return Icon(Icons.train);
      case 'street_address':
        return Icon(Icons.assistant_photo);
      case 'route':
        return Icon(Icons.streetview);
      case 'establishment':
        return Icon(Icons.store);
      case 'locality':
        return Icon(Icons.location_city);
    }
    return Icon(Icons.location_on);
  }
}
