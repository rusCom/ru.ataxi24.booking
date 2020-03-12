import 'package:booking/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:flutter/material.dart';

class NewOrderCalcRoutePointWidget extends StatelessWidget{
  final int routePointIndex;

  NewOrderCalcRoutePointWidget(this.routePointIndex);

  @override
  Widget build(BuildContext context) {
    RoutePoint routePoint = MainApplication().curOrder.routePoints[routePointIndex];

    return ListTile(
      title: Text(routePoint.name),
    );
  }
}