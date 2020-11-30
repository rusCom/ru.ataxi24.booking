import 'package:booking/models/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/services/rest_service.dart';
import 'package:booking/ui/orders/bottom_sheets/order_modal_bottom_sheets.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'order_sliding_panel_bottom.dart';
import 'order_sliding_panel_caption.dart';
import 'order_sliding_panel_wishes_tile.dart';

class OrderSlidingPanel extends StatelessWidget {
  final Widget child;

  OrderSlidingPanel({this.child});

  double getMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.65;
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 100,
      maxHeight: getMaxHeight(context),
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      borderRadius: new BorderRadius.circular(18),
      panel: Container(
        child: Column(
          children: <Widget>[
            OrderSlidingPanelCaption(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        MainApplication().curOrder.paymentType().iconName,
                        width: Const.modalBottomSheetsLeadingSize,
                        height: Const.modalBottomSheetsLeadingSize,
                      ),
                      title: Text("Стоимость поездки"),
                      subtitle: Text(MainApplication().curOrder.paymentType().choseName),
                      trailing: Text(MainApplication().curOrder.cost + " \u20BD"),
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: MainApplication().curOrder.routePoints.length,
                        itemBuilder: (BuildContext context, int index) {
                          RoutePoint routePoint = MainApplication().curOrder.routePoints[index];
                          String imageLocation = "assets/icons/ic_onboard_pick_up.png";
                          if (index == 0) {
                            String subtitle = "Указать подъезд";
                            String name = routePoint.name;
                            if (routePoint.isNoteSet){
                              subtitle = routePoint.dsc;
                              name = name + ", " + routePoint.note;
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(imageLocation),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(name),
                              subtitle: Text(subtitle),
                              onTap: () async {
                                if (!routePoint.isNoteSet){
                                  String note = await OrderModalBottomSheets.orderNoteRes(context);
                                  MainApplication().curOrder.note(note);
                                }
                              },
                            );
                          }
                          if (index == MainApplication().curOrder.routePoints.length - 1) {
                            imageLocation = "assets/icons/ic_onboard_destination.png";
                          } else {
                            imageLocation = "assets/icons/ic_onboard_address.png";
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(imageLocation),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(routePoint.name),
                            subtitle: Text(routePoint.dsc),
                          );
                        },
                      ),
                    ),
                    OrderSlidingPanelWishesTile(MainApplication().curOrder.orderWishes),
                  ],
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: OrderSlidingPanelBottom(),
              ),
            ),
          ],
        ),
      ),
      collapsed: OrderSlidingPanelCaption(),
    );
  }
}
