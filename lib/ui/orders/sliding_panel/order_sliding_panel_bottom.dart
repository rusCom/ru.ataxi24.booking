import 'package:booking/models/main_application.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class OrderSlidingPanelBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MainApplication().curOrder.canDeny
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _showDenyOrderDialog(context);
                      },
                      heroTag: "_denyOrder",
                    ),
                    Center(
                      child: Text('Отменить'),
                    ),
                    Center(
                      child: Text('поездку'),
                    ),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                child: Icon(
                  Icons.call,
                  color: Colors.lightGreen,
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  MainApplication().launchURL("tel://" + MainApplication().curOrder.dispatcherPhone);
                },
                heroTag: "_dispathcerCall",
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
        MainApplication().curOrder.agent != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(
                        Icons.phone_in_talk,
                        color: Colors.green,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        MainApplication().launchURL("tel://" + MainApplication().curOrder.agent.phone);
                      },
                      heroTag: "_agentCall",
                    ),
                    Center(
                      child: Text('Позвонить'),
                    ),
                    Center(
                      child: Text('водителю'),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  _showDenyOrderDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              // margin: EdgeInsets.only(left: 8, right: 8),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTileMoreCustomizable(
                      title: new Text("Долгая подача автомобиля"),
                      onTap: (details) async {
                        await MainApplication().curOrder.deny("Долгая подача автомобиля");
                        Navigator.pop(context);
                      }),
                  ListTileMoreCustomizable(
                      title: new Text("Не указывать причину"),
                      onTap: (details) async {
                        await MainApplication().curOrder.deny("");
                        Navigator.pop(context);
                      }),
                  ListTileMoreCustomizable(
                      title: new Text("Не отменять поездку"),
                      onTap: (details) async {
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          );
        });
  } // _showDenyOrderDialog
}
