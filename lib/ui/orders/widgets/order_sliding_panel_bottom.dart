import 'package:booking/models/main_application.dart';
import 'package:flutter/material.dart';

class OrderSlidingPanelBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                onPressed: () {},
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
        ),
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
                onPressed: () {},
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
        MainApplication().curOrder.agent.phone != ""
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
                      onPressed: () {},
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
}
