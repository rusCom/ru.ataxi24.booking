import 'dart:convert';

import 'package:booking/bloc/geo_bloc.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/geo_service.dart';
import 'package:booking/ui/route_point/route_point_search_bar.dart';
import 'package:flutter/material.dart';

class RoutePointScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bool isFirst;


  RoutePointScreen({this.isFirst = false}): super();

  @override
  Widget build(BuildContext context) {
    print("_RoutePointScreenState build");
    String hintText = "Куда поедите?";
    if (isFirst){hintText = "Откуда Вас забрать?";}
    var geoAutocompleteBloc = GeoAutocompleteBloc();
    RoutePointSearchBar routePointSearchBar = new RoutePointSearchBar(
      hintText: hintText,
      onChanged: (value) {
        geoAutocompleteBloc.autocomplete(context, value);
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
          stream: geoAutocompleteBloc.geoBlocStream,
          builder: (context, snapshot) {
            // print("snapshot.data = " + snapshot.data);
            if ((snapshot.hasData) && (snapshot.data != null) && (snapshot.data != "null_")) {
              if (snapshot.data == "searching_") {
                return Center(
                  child: CircularProgressIndicator(),
                );
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
                        //  print(routePoint.name);
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
            }
            return Container(
              child: Center(
                child: Text('Ничего не найдено'),
              ),
            );
          }),
    );
  }


}