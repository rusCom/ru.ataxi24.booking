import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderFindAgentPanel extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 100,
      maxHeight: 220,
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
              child: Text("Поиск машины", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(
                "Подбираем автомобиль на ваш заказ",
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(width: 56, height: 56, child: Icon(Icons.clear)),
                            onTap: () {},
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Отменить'),
                      ),
                      Center(
                        child: Text('поездку'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.lightGreen, // button color
                          child: InkWell(
                            splashColor: Colors.amber, // inkwell color
                            child: SizedBox(width: 56, height: 56, child: Icon(Icons.call)),
                            onTap: () {},
                          ),
                        ),
                      ),
                      Center(
                        child: Text('Позвонить'),
                      ),
                      Center(
                        child: Text('диспетчеру'),
                      ),
                    ],
                  ),
                ),
              ],
            )
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
              child: Text("Поиск машины", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Text(
                "Подбираем автомобиль на ваш заказ",
              ),
            ),
          ],
        ),
      ),
    );
  }

}