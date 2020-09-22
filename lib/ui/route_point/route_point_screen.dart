import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/route_point/route_point_search_bar.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RoutePointScreen extends StatelessWidget {
  final String TAG = (RoutePointScreen).toString(); // ignore: non_constant_identifier_names
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bool isFirst, viewReturn;

  RoutePointScreen({this.isFirst = false, this.viewReturn = true}) : super();

  @override
  Widget build(BuildContext context) {
    String hintText = "Куда поедите?";
    if (isFirst) {
      hintText = "Откуда Вас забрать?";
    }

    DebugPrint().log(TAG, "build", MapMarkersService().pickUpRoutePoint);

    RoutePointSearchBar routePointSearchBar = new RoutePointSearchBar(
      hintText: hintText,
      onChanged: (value) {
        _autocomplete(value);
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: routePointSearchBar,
      ),
      body: StreamBuilder(
          stream: AppBlocs().geoAutocompleteStream,
          builder: (context, snapshot) {
            if ((snapshot.data == null) || (!snapshot.hasData) || (snapshot.data == "null_")) {
              return Column(
                children: <Widget>[
                  viewReturn ? _returnRoutePoint(context) : Container(),
                  _nearbyRoutePoint(context),
                ],
              );
            }
            if (snapshot.data == "searching_") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == "not_found_") {
              return Center(child: Text("Ничего не найдено"));
            }
            List<RoutePoint> routePoints = snapshot.data;
            return Container(
              child: ListView.builder(
                itemCount: routePoints.length,
                itemBuilder: (BuildContext context, int index) {
                  RoutePoint routePoint = routePoints.elementAt(index);
                  return ListTile(
                    title: Text(routePoint.name),
                    subtitle: Text(routePoint.dsc),
                    leading: routePoint.getIcon(),
                    onTap: () async {
                      if (routePoint.type == 'route') {
                        if (routePoint.detail == '0') {
                          GeoService().detail(routePoint);
                        }
                        routePointSearchBar.setText(routePoint.name);
                      } else if (routePoint.detail == '1') {
                        Navigator.pop(context, routePoint);
                      } else {
                        GeoService().detail(routePoint).then((routePoint) {
                          Navigator.pop(context, routePoint);
                        });
                      }
                    },
                  );
                },
                // separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            );
          }),
    );
  }

  Widget _nearbyRoutePoint(BuildContext context) {
    if (MainApplication().nearbyRoutePoint != null) {
      var routePoints = MainApplication().nearbyRoutePoint;
      return Expanded(
        child: ListView.builder(
          itemCount: routePoints.length,
          itemBuilder: (BuildContext context, int index) {
            RoutePoint routePoint = routePoints.elementAt(index);
            return ListTile(
              title: Text(routePoint.name),
              subtitle: Text(routePoint.dsc),
              leading: routePoint.getIcon(),
              onTap: () async {
                DebugPrint().log(TAG, "onTap", routePoint.name);
                if (routePoint.detail == '1') {
                  Navigator.pop(context, routePoint);
                } else {
                  GeoService().detail(routePoint).then((routePoint) {
                    Navigator.pop(context, routePoint);
                  });
                }
              },
            );
          },
        ),
      );
    }


    return Container();
  }

  Widget _returnRoutePoint(BuildContext context) {
    if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
      if (MainApplication().curOrder.routePoints.first.placeId != MainApplication().curOrder.routePoints.last.placeId) {
        return ListTileMoreCustomizable(
          leading: Icon(Icons.cached),
          title: Text(MainApplication().curOrder.routePoints.first.name),
          subtitle: Text(MainApplication().curOrder.routePoints.first.dsc),
          horizontalTitleGap: 0.0,
          onTap: (details) => Navigator.pop(context, RoutePoint.copy(MainApplication().curOrder.routePoints.first)),
        );
      }
    }
    return Container();
  }

  _autocomplete(String keyword) {
    if (keyword.isNotEmpty && keyword != "" && keyword.length > 2) {
      AppBlocs().geoAutocompleteController.sink.add("searching_");
      GeoService().autocomplete(keyword).then((result) {
        if (result == null)
          AppBlocs().geoAutocompleteController.sink.add("not_found_");
        else {
          AppBlocs().geoAutocompleteController.sink.add(result);
        }
      }).catchError((e) {
        DebugPrint().log(TAG, "_autocomplete catchError", e.toString());
      });
    } else {
      AppBlocs().geoAutocompleteController.sink.add("null_");
    }
  }
}
