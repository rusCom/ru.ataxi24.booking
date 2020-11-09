import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/models/preferences.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/map_markers_service.dart';
import 'package:booking/ui/route_point/route_point_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'bottom_sheets/order_modal_bottom_sheets.dart';
import 'widgets/new_order_calc_tariff_check_widget.dart';
import 'widgets/new_order_calc_main_button.dart';
import 'widgets/new_order_route_points_reorder_dialog.dart';

class NewOrderCalcScreen extends StatelessWidget {
  final NewOrderMainButton newOrderMainButton = NewOrderMainButton();

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
                    leading: CircleAvatar(
                      child: Image.asset("assets/icons/ic_onboard_pick_up.png"),
                      backgroundColor: Colors.transparent,
                    ),
                    title: StreamBuilder(
                      stream: AppBlocs().orderStateStream,
                      builder: (context, snapshot) {
                        return Text(
                          MainApplication().curOrder.routePoints.first.name,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    trailing: SizedBox(
                      width: 110,
                      height: 40,
                      child: FlatButton(
                        onPressed: () async {
                          if (MainApplication().curOrder.routePoints.first.notes.length > 0) {
                            OrderModalBottomSheets.orderNotes(context);
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                  ),
                  ListTileMoreCustomizable(
                    leading: CircleAvatar(
                      child: Image.asset("assets/icons/ic_onboard_destination.png"),
                      backgroundColor: Colors.transparent,
                    ),
                    title: StreamBuilder(
                      stream: AppBlocs().orderStateStream,
                      builder: (context, snapshot) {
                        return Text(
                          MainApplication().curOrder.getLastRouteName(),
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    subtitle: StreamBuilder(
                      stream: AppBlocs().orderStateStream,
                      builder: (context, snapshot) {
                        return Text(
                          MainApplication().curOrder.getLastRouteDsc(),
                          style: TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
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
                            MainApplication().curOrder.calcOrder();
                          }
                        }
                      },
                    ),
                    horizontalTitleGap: 0.0,
                    onTap: (details) async {
                      if (MainApplication().curOrder.orderState == OrderState.new_order_calculated) {
                        if (MainApplication().curOrder.routePoints.length == 2) {
                          RoutePoint routePoint = await Navigator.push<RoutePoint>(context, MaterialPageRoute(builder: (context) => RoutePointScreen(viewReturn: false)));
                          if (routePoint != null) {
                            MainApplication().curOrder.addRoutePoint(routePoint, isLast: true);
                          }
                        } else {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderRoutePointsReorderDialog()));
                          MainApplication().curOrder.calcOrder();
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
                                icon: SvgPicture.asset(
                                  MainApplication().curOrder.paymentType().iconName,
                                  width: 32,
                                  height: 32,
                                  color: Colors.deepOrangeAccent,
                                ),
                                label: Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    child: Text(
                                      MainApplication().curOrder.paymentType().name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (MainApplication().curOrder.paymentTypes.length > 1) {
                                    OrderModalBottomSheets.paymentTypes(context);
                                  }
                                },
                              );
                            }),
                      ),
                      Container(height: 40, child: VerticalDivider(color: Colors.amber)),
                      Expanded(
                        child: FlatButton.icon(
                          icon: StreamBuilder(
                              stream: AppBlocs().newOrderWishesStream,
                              builder: (context, snapshot) {
                                return wishesCount();
                              }),
                          label: Text("Пожелания"),
                          onPressed: () {
                            OrderModalBottomSheets.orderWishes(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        newOrderMainButton,
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

  Widget wishesCount() {
    if (MainApplication().curOrder.orderWishes.countWithOutWorkDate == 0) {
      return SvgPicture.asset(
        "assets/icons/ic_wishes.svg",
        width: 24,
        height: 24,
        color: Colors.deepOrangeAccent,
      );
    }
    return ClipOval(
      child: Container(
        color: Colors.amberAccent,
        height: 24,
        width: 24,
        child: Center(
          child: Text(MainApplication().curOrder.orderWishes.countWithOutWorkDate.toString()),
        ),
      ),
    );
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
    MainApplication().mapController.animateCamera(CameraUpdate.newLatLngBounds(MapMarkersService().mapBounds(), Preferences().systemMapBounds));
  }
}
