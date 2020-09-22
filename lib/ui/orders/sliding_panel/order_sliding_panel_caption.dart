import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OrderSlidingPanelCaption extends StatelessWidget {

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
    return Column(
      children: [
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
    );
  }
}
