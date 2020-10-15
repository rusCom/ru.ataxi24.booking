import 'package:booking/models/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'order_sliding_panel_bottom.dart';
import 'order_sliding_panel_caption.dart';

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
                      leading: CircleAvatar(backgroundImage: AssetImage(MainApplication().curOrder.paymentType().iconName), backgroundColor: Colors.white,),
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
                          String imageLocation = "assets/icons/ic_onboard_address.png";
                          if (index == 0) {
                            imageLocation = "assets/icons/ic_onboard_pick_up.png";
                          }
                          if (index == MainApplication().curOrder.routePoints.length - 1) {
                            imageLocation = "assets/icons/ic_onboard_destination.png";
                          }
                          return ListTile(
                            leading: CircleAvatar(backgroundImage: AssetImage(imageLocation), backgroundColor: Colors.white,),
                            title: Text(routePoint.name),
                            subtitle: Text(routePoint.dsc),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(backgroundImage: AssetImage("assets/icons/ic_date_range_black.png"), backgroundColor: Colors.white,),
                      title: Text("Какой либо текст"),

                    ),
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
