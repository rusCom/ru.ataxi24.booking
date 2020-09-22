import 'package:booking/models/main_application.dart';
import 'package:booking/models/order.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/ui/orders/bottom_sheets/order_modal_bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewOrderMainButton extends StatelessWidget {
  String getCaption(){
    if (MainApplication().curOrder.orderState == OrderState.new_order_calculating)
      return "Расчет стоимости ...";
    if (MainApplication().curOrder.workDate != null){
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final aDate = DateTime(MainApplication().curOrder.workDate.year, MainApplication().curOrder.workDate.month, MainApplication().curOrder.workDate.day);
      String date = "";
      if(aDate == today){
        date = "сегодня на " + DateFormat('HH:mm', 'ru').format(MainApplication().curOrder.workDate);
      }
      else if (aDate == tomorrow){
        date = "завтра на " + DateFormat('HH:mm', 'ru').format(MainApplication().curOrder.workDate);
      }
      else {
        date = DateFormat('dd MMMM на HH:mm', 'ru').format(MainApplication().curOrder.workDate);
      }


      return "Запланировать поездку\n" + date;
    }

    return "Заказать такси";
  }
  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: StreamBuilder<OrderState>(
          stream: AppBlocs().orderStateStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: RaisedButton(
                      onPressed: snapshot.data == OrderState.new_order_calculated ? () {
                        MainApplication().curOrder.add();
                      } : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(18), ),
                      ),
                      splashColor: Colors.yellow[200],
                      textColor: Colors.white,
                      color: Colors.amber,
                      disabledColor: Colors.grey,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getCaption(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only( bottomRight: Radius.circular(18)),
                    ),
                    icon: Icon(Icons.date_range),
                    label: Text(""),
                    splashColor: Colors.yellow[200],
                    textColor: Colors.white,
                    color: Colors.amber,
                    disabledColor: Colors.grey,
                    onPressed: snapshot.data == OrderState.new_order_calculated ? () {
                      OrderModalBottomSheets.orderDate(context);
                    } : null,
                  ),
                )
              ],
            );
          }),
    );
  }
}
