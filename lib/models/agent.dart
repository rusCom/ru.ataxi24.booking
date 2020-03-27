import 'package:google_maps_flutter/google_maps_flutter.dart';

class Agent{
  final String id;
  final String name;
  final String car;
  final String phone;
  final String lt;
  final String ln;

  Agent({this.id, this.name, this.car, this.phone, this.lt, this.ln});

  factory Agent.fromJson(Map<String, dynamic> jsonData) {
    // print("RoutePoint.fromJson json = " + jsonData.toString());
    return Agent(
      id: jsonData['id'] != null ? jsonData['id'] : "",
      name: jsonData['name'] != null ? jsonData['name'] : "",
      car: jsonData['car'] != null ? jsonData['car'] : "",
      phone: jsonData['phone'] != null ? jsonData['phone'] : "",
      lt: jsonData['lt'] != null ? jsonData['lt'] : "",
      ln: jsonData['ln'] != null ? jsonData['ln'] : "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "car": car,
    "phone": phone,
    "lt": lt,
    "ln": ln,
  };

  @override
  String toString() {
    return toJson().toString();
  }

  LatLng get location{
    return new LatLng(double.parse(lt), double.parse(ln));
  }


}