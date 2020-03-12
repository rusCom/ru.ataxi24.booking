import 'package:booking/models/route_point.dart';
import 'package:booking/ui/route_point/route_point_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewOrderNotesDialog extends StatelessWidget {
  final RoutePoint _routePoint;

  NewOrderNotesDialog(this._routePoint);

  @override
  Widget build(BuildContext context) {
    RoutePointSearchBar searchBar = RoutePointSearchBar(
      hintText: "Введите к чему подъехать или выберите из списка",
    );
    // print(_routePoint.placeId);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: searchBar,
      ),
      body: ListView.builder(
        itemCount: _routePoint.notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.note),
            title: Text(_routePoint.notes[index]),
            onTap: () => Navigator.pop(context, _routePoint.notes[index]),

          );
        },
      ),
    );
  }
}
