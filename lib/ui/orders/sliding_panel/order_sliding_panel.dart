import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'order_sliding_panel_bottom.dart';

class OrderSlidingPanel extends StatelessWidget {
  final Widget child;

  OrderSlidingPanel({this.child});

  double getMaxHeight(BuildContext context) {
    return 200;
    if (MainApplication().curOrder.orderState == OrderState.search_car) return 200;
    return MediaQuery.of(context).size.height * 0.8;
  }

  String getTitle() {
    switch (MainApplication().curOrder.orderState) {
      case OrderState.search_car:
        return "Поиск машины";
      case OrderState.drive_to_client:
        return "К Вам едет";
      case OrderState.drive_at_client:
        return "Вас ожидает";
      case OrderState.paid_idle:
        return "Платный простой";
      case OrderState.client_in_car:
        return "В пути";
      default:
        return "Не известный статус";
    }
  }

  String getSubTitle() {
    switch (MainApplication().curOrder.orderState) {
      case OrderState.search_car:
        return "Подбираем автомобиль на ваш заказ";
      default:
        return MainApplication().curOrder.agent.car;
    }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTitle(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  MainApplication().curOrder.orderState == OrderState.search_car
                      ? JumpingDotsProgressIndicator(
                          fontSize: 20.0,
                        )
                      : Container(),
                ],
              ),
            ),
            Center(
              child: Text(getSubTitle()),
            ),
            SizedBox(
              height: 0.0,
            ),
            Expanded(
              child: Container(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTitle(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  MainApplication().curOrder.orderState == OrderState.search_car
                      ? JumpingDotsProgressIndicator(
                    fontSize: 20.0,
                  )
                      : Container(),
                ],
              ),
            ),
            Center(
              child: Text(getSubTitle()),
            ),
          ],
        ),
      ),
    );
  }
}
