import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'bottom_sheets/order_modal_bottom_sheets.dart';
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
                            // _showNoteDialog(context);
                            OrderModalBottomSheets.orderNote(context);
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
                          RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen(viewReturn:  false)));
                          if (routePoint != null) {
                            MainApplication().curOrder.addRoutePoint(routePoint, isLast: true);
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
                        child: StreamBuilder(
                            stream: AppBlocs().newOrderPaymentStream,
                            builder: (context, snapshot) {
                              return FlatButton.icon(
                                icon: Image.asset(
                                  MainApplication().curOrder.paymentType.iconName,
                                  width: 30,
                                  height: 30,
                                ),
                                label: Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    child: Text(
                                      MainApplication().curOrder.paymentType.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                onPressed: () => _showPaymentsDialog(context),
                              );
                            }),
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

  _showPaymentsDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              // margin: EdgeInsets.only(left: 8, right: 8),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MainApplication().curOrder.isPaymentType("cash")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("cash").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("cash").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "cash";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("corporation")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("corporation").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("corporation").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "corporation";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("sberbank")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("sberbank").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("sberbank").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "sberbank";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("bonuses")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("bonuses").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("bonuses").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "bonuses";
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
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
