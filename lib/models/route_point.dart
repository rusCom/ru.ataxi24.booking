import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePoint {
  final String name;
  final String dsc;
  final String lt;
  final String ln;
  final String type;
  final String place_id;
  final String detail;
  String note = "";

  RoutePoint({this.name, this.dsc, this.lt, this.ln, this.type, this.place_id, this.detail});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    print("RoutePoint.fromJson json = " + json.toString());
    return RoutePoint(
      name: json['name'] != null ? json['name'] : "",
      dsc: json['dsc'] != null ? json['dsc'] : "",
      lt: json['lt'] != null ? json['lt'] : "",
      ln: json['ln'] != null ? json['ln'] : "",
      type: json['type'] != null ? json['type'] : "",
      place_id: json['place_id'] != null ? json['place_id'] : "",
      detail: json['detail'] != null ? json['detail'] : "0",
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'dsc': dsc,
        'lt': lt,
        'ln': ln,
      };


  @override
  String toString() {
    return toJson().toString();
  }

  LatLng getLocation(){
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
