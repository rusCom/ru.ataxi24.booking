import 'package:booking/models/main_application.dart';
import 'package:booking/models/route_point.dart';
import 'package:booking/ui/orders/widgets/order_sliding_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderCarriedOutPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrderSlidingPanel(
      title: "В пути",
      subTitle: MainApplication().curOrder.agent.car,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: MainApplication().curOrder.routePoints.length,
                itemBuilder: (BuildContext context, int index) {
                  RoutePoint routePoint = MainApplication().curOrder.routePoints[index];
                  String imageLocation = "assets/icons/ic_conformation_point.png";
                  if (index == 0){imageLocation = "assets/icons/ic_conformation_pickup.png";}
                  if (index == MainApplication().curOrder.routePoints.length - 1){imageLocation = "assets/icons/ic_conformation_destination.png";}

                  return ListTile(
                    title: Text(routePoint.name),
                    subtitle: Text(routePoint.dsc),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(imageLocation),
                    ),
                  );
                }),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
            ListTile(
              title: Text("Стоимость поездки"),
              trailing: Text("195"),
            ),
          ],
        ),
      ),
    );
  }
}
