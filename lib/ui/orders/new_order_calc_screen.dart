import 'package:booking/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'widgets/new_order_calc_tariff_check_widget.dart';
import 'widgets/new_order_calc_main_button.dart';
import 'widgets/new_order_notes_dialog.dart';
import 'widgets/new_order_route_points_reorder_dialog.dart';

class NewOrderCalcScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 68,
          left: 0,
          right: 0,
          child: Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            margin: EdgeInsets.only(left: 8, right: 8),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StreamBuilder(
                      stream: AppBlocs().newOrderTariffStream,
                      builder: (context, snapshot) {
                        return NewOrderCalcTariffCheckWidget();
                      }),
                  ListTileMoreCustomizable(
                    leading: Icon(Icons.person_pin_circle),
                    title: StreamBuilder(
                        stream: AppBlocs().orderStateStream,
                        builder: (context, snapshot) {
                          return Text(
                            MainApplication().curOrder.routePoints.first.name,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                    trailing: SizedBox(
                      width: 110,
                      height: 40,
                      child: FlatButton(
                        onPressed: () async {
                          if (MainApplication().curOrder.routePoints.first.notes.length > 0) {
                            String note = await Navigator.push<String>(
                                context, MaterialPageRoute(builder: (context) => NewOrderNotesDialog(MainApplication().curOrder.routePoints.first)));
                            if (note != null) {
                              MainApplication().curOrder.routePoints.first.note = note;
                            }
                          } else {
                            _showNoteDialog(context);
                          }
                        },
                        child: StreamBuilder(
                            stream: AppBlocs().newOrderNoteStream,
                            builder: (context, snapshot) {
                              return Text(
                                MainApplication().curOrder.routePoints.first.note,
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              );
                            }),
                      ),
                    ),
                    horizontalTitleGap: 0.0,
                    onTap: (details) {},
                    onLongPress: (details) {
                      print("onLongPress first point");
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                  ),
                  ListTileMoreCustomizable(
                    leading: Icon(Icons.add_location),
                    title: StreamBuilder(
                        stream: AppBlocs().orderStateStream,
                        builder: (context, snapshot) {
                          return Text(
                            MainApplication().curOrder.getLastRouteName(),
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
                          if (MainApplication().curOrder.routePoints.length == 2) {
                            RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                            if (routePoint != null) {
                              MainApplication().curOrder.addRoutePoint(routePoint);
                            }
                          } else {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderRoutePointsReorderDialog()));
                            MainApplication().curOrder.orderState = OrderState.new_order_calculating;
                          }
                        }
                      },
                    ),
                    horizontalTitleGap: 0.0,
                    onTap: (details) async {
                      if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
                        if (MainApplication().curOrder.routePoints.length == 2) {
                          RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen()));
                          if (routePoint != null) {
                            MainApplication().curOrder.routePoints.last = routePoint;
                          }
                        } else {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderRoutePointsReorderDialog()));
                          MainApplication().curOrder.orderState = OrderState.new_order_calculating;
                        }
                      }
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Divider(
                    color: Colors.amber,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton.icon(
                          icon: Icon(Icons.payment),
                          label: Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              child: Text(
                                'Корпоративный счет',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                                ),
                                backgroundColor: Colors.white,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: new Wrap(
                                      children: <Widget>[
                                        new ListTile(
                                          leading: Image.asset("assets/icons/ic_payment_cash.png"),
                                          title: new Text('Наличные'),
                                          onTap: () => {},
                                        ),
                                        new ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Сбербанк Онлайн'),
                                          onTap: () => {},
                                        ),
                                        new ListTile(
                                          leading: new Icon(Icons.videocam),
                                          title: new Text('Корпоративный счет'),
                                          onTap: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                      Container(height: 40, child: VerticalDivider(color: Colors.amber)),
                      Expanded(
                        child: FlatButton.icon(
                          icon: Icon(Icons.wrap_text),
                          label: Text("Пожелания"),
                          onPressed: () => null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        NewOrderMainButton(),
        Positioned(
          bottom: 340,
          right: 8,
          child: FloatingActionButton(
            heroTag: '_mapBounds',
            backgroundColor: Colors.white,
            onPressed: mapBounds,
            child: Icon(
              Icons.near_me,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: 340,
          left: 8,
          child: FloatingActionButton(
            heroTag: '_backPressed',
            backgroundColor: Colors.white,
            onPressed: backPressed,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  _showNoteDialog(BuildContext context) {
    final entranceController = TextEditingController();
    final noteController = TextEditingController();
    Alert(
        context: context,
        title: MainApplication().curOrder.routePoints.first.name,
        content: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: entranceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Укажите номер подъезда',
                icon: Icon(
                  Icons.format_list_numbered,
                  color: Color(0xFF757575),
                ),
              ),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'или к чему подъехать',
                icon: Icon(
                  Icons.note,
                  color: Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              if (entranceController.text != "") {
                MainApplication().curOrder.routePoints.first.note = entranceController.text + " подъезд";
              } else if (noteController.text != "") {
                MainApplication().curOrder.routePoints.first.note = noteController.text;
              }
            },
            child: Text(
              "Сохранить",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void backPressed() {
    if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
      LatLng location = MainApplication().curOrder.routePoints.first.getLocation();
      MainApplication().curOrder.orderState = OrderState.new_order;
      MapMarkersService().pickUpLocation = location;

      MainApplication().mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: location,
                zoom: 17.0,
              ),
            ),
          );
    }
  }

  void mapBounds() {
    MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), 50));
  }
}
