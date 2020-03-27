import 'package:booking/ui/orders/widgets/order_sliding_panel_bottom.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderSlidingPanel extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget child;

  OrderSlidingPanel({this.title, this.subTitle, this.child});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 100,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      borderRadius: new BorderRadius.circular(18),
      panel: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Center(
              child: Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(subTitle),
            ),
            SizedBox(
              height: 18.0,
            ),
            Expanded(
              child: child,

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
      collapsed: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Center(
              child: Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(subTitle),
            ),
          ],
        ),
      ),
    );
  }
}
