import 'package:booking/models/route_point.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SystemGeocodeAddressReplaceScreen extends StatefulWidget {
  final TAG = "SystemGeocodeAddressReplaceScreen"; // ignore: non_constant_identifier_names
  final RoutePoint routePoint;
  final LatLng location;

  const SystemGeocodeAddressReplaceScreen({Key key, this.routePoint, this.location}) : super(key: key);

  @override
  _SystemGeocodeAddressReplaceScreenState createState() => _SystemGeocodeAddressReplaceScreenState();
}

class _SystemGeocodeAddressReplaceScreenState extends State<SystemGeocodeAddressReplaceScreen> {
  RoutePoint newRoutePoint;

  @override
  Widget build(BuildContext context) {
    DebugPrint().log(widget.TAG, "build", widget.routePoint.toString());
    DebugPrint().log(widget.TAG, "build", widget.location.toString());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Заменить данные геокодинга по координатам"),
            Text(widget.location.toString()),
            Text(widget.routePoint.name),
            Text(widget.routePoint.dsc),
            RaisedButton(
              child: Text("Выбрать новый адрес"),
              onPressed: () async {
                RoutePoint toRoutePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                setState(() {
                  newRoutePoint = toRoutePoint;
                });
              },
            ),
            newRoutePoint != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("На следующую точку геокодинга"),
                      Text("name: " + newRoutePoint.name),
                      Text("dsc: " + newRoutePoint.dsc),
                      Text("placeID: " + newRoutePoint.placeId),
                      RaisedButton(
                        child: Text("Заменить. Подумай, прежде чем нажать"),
                        onPressed: () async {
                          await GeoService().geocodeReplaceAddress(widget.location.latitude.toString(), widget.location.longitude.toString(), newRoutePoint.placeId);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
