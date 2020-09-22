import 'package:booking/models/route_point.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';

class GeoCodeReplaceScreen extends StatefulWidget {
  final RoutePoint fromRoutePoint;

  GeoCodeReplaceScreen(this.fromRoutePoint);

  @override
  _GeoCodeReplaceScreenState createState() => _GeoCodeReplaceScreenState();
}

class _GeoCodeReplaceScreenState extends State<GeoCodeReplaceScreen> {
  final TAG = (GeoCodeReplaceScreen).toString(); // ignore: non_constant_identifier_names
  RoutePoint toRoutePoint;

  @override
  Widget build(BuildContext context) {
    DebugPrint().log(TAG, "build", widget.fromRoutePoint.toString());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Заменить точку геокодинга"),
            Text("name: " + widget.fromRoutePoint.name),
            Text("dsc: " + widget.fromRoutePoint.dsc),
            Text("placeID: " + widget.fromRoutePoint.placeId),
            RaisedButton(
              onPressed: () async {
                RoutePoint destinationRoutePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                if (destinationRoutePoint != null) {
                  setState(() {
                    toRoutePoint = destinationRoutePoint;
                    DebugPrint().log(TAG, "new point result = ", destinationRoutePoint.toString());
                  });
                }
              },
              child: Text("Выбрать новую точку"),
            ),
            toRoutePoint != null ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("На следующую точку геокодинга"),
                Text("name: " + toRoutePoint.name),
                Text("dsc: " + toRoutePoint.dsc),
                Text("placeID: " + toRoutePoint.placeId),
                RaisedButton(
                  child: Text("Заменить. Подумай, прежде чем нажать"),
                  onPressed: () async {
                    GeoService().geocodeReplace(widget.fromRoutePoint.placeId, toRoutePoint.placeId);
                    Navigator.pop(context);
                  },

                ),

              ],


            ):Container(),

            RaisedButton(
              child: Text("Очистить кэш по геокодингу для выбранной точки."),

              onPressed: () async {
                GeoService().geocodeClear(widget.fromRoutePoint);
                Navigator.pop(context);
              },

            ),
          ],
        ),
      ),
    );
  }
}
