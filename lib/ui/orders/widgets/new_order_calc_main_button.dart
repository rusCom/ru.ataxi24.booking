import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NewOrderMainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        constraints: const BoxConstraints(minWidth: double.infinity),
        alignment: Alignment.center,
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: StreamBuilder<OrderState>(
              stream: AppBlocs().orderStateStream,
              builder: (context, snapshot) {
                return RaisedButton(
                  onPressed: snapshot.data == OrderState.new_order_calculated ? () {
                    Logger().d(MainApplication().curOrder.toString());
                  } : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
                  ),
                  splashColor: Colors.yellow[200],
                  textColor: Colors.white,
                  color: Colors.amber,
                  disabledColor: Colors.grey,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data == OrderState.new_order_calculated ? "Заказать" : "Расчет ...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
