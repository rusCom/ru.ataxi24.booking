import 'package:booking/models/main_application.dart';
import 'package:booking/models/order_wishes.dart';
import 'package:booking/ui/orders/wishes/order_wishes_baby_seats.dart';
import 'package:booking/ui/orders/wishes/order_wishes_driver_note.dart';
import 'package:booking/ui/orders/wishes/order_wishes_title.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class OrderModalBottomSheets {
  static const borderRadius = Radius.circular(10.0);

  static orderWishes(BuildContext context) {
    OrderWishes orderWishes = MainApplication().curOrder.orderWishes;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 1,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: borderRadius, topLeft: borderRadius), color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
                  child: Column(children: [
                    OrderWishesTitle("Пожелания"),
                    OrderWishesDriverNote(value: orderWishes.driverNote, onChanged: (value) => orderWishes.driverNote = value),
                    Expanded(
                      child: ListView(controller: scrollController, children: [
                        MainApplication().curOrder.orderTariff.wishesBabySeats
                            ? OrderWishesBabySeats(orderBabySeats: orderWishes.orderBabySeats, onChanged: (value) => orderWishes.orderBabySeats = value)
                            : null,
                      ]),
                    ),
                  ]),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      DebugPrint().flog(orderWishes);
      MainApplication().curOrder.orderWishes = orderWishes;
      MainApplication().curOrder.calcOrder();
    });
  }

  static orderDate(BuildContext context) {
    DateTime choseDateTime = DateTime.now().add(Duration(minutes: 46));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Выберите время подачи",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 150,
                child: CupertinoDatePicker(
                  minimumDate: DateTime.now().add(Duration(minutes: 45)),
                  initialDateTime: DateTime.now().add(Duration(minutes: 46)),
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime dateTime) {
                    choseDateTime = dateTime;
                  },
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          MainApplication().curOrder.workDate = null;
                          Navigator.of(context).pop();
                        },
                        child: Text("На текущее время"),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          MainApplication().curOrder.workDate = choseDateTime;
                          Navigator.of(context).pop();
                        },
                        child: Text("Выбрать"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        );
      },
    );
  }

  static orderNotes(BuildContext context) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 1,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: borderRadius, topLeft: borderRadius), color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
                  child: Column(
                    children: [
                      Text(
                        MainApplication().curOrder.routePoints.first.name,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        "Введите к чему подъехать или выберите из списка",
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            Navigator.of(context).pop();
                          },
                          controller: noteController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Введите к чему подъехать',
                            icon: Icon(
                              Icons.note,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: MainApplication().curOrder.routePoints.first.notes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Icon(Icons.add_circle),
                              title: Text(MainApplication().curOrder.routePoints.first.notes[index]),
                              onTap: () {
                                MainApplication().curOrder.routePoints.first.note = MainApplication().curOrder.routePoints.first.notes[index];
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      if (noteController.text != "") {
        MainApplication().curOrder.routePoints.first.note = noteController.text;
      }
    });
  }

  static orderNote(BuildContext context) {
    final entranceController = TextEditingController();
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                MainApplication().curOrder.routePoints.first.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              TextField(
                autofocus: true,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                },
                controller: entranceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Укажите номер подъезда',
                  icon: Icon(
                    Icons.format_list_numbered,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
              TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                },
                controller: noteController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'или к чему подъехать',
                  icon: Icon(
                    Icons.note,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      String note;
      if (entranceController.text != "") {
        note = entranceController.text + " подъезд";
      } else if (noteController.text != "") {
        note = noteController.text;
      }
      MainApplication().curOrder.routePoints.first.note = note;
    });
  }

  static paymentTypes(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              // margin: EdgeInsets.only(left: 8, right: 8),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MainApplication().curOrder.isPaymentType("cash")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("cash").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("cash").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "cash";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("corporation")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("corporation").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("corporation").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "corporation";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("sberbank")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("sberbank").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("sberbank").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "sberbank";
                          },
                        )
                      : Container(),
                  MainApplication().curOrder.isPaymentType("bonuses")
                      ? new ListTileMoreCustomizable(
                          leading: Image.asset(
                            MainApplication().curOrder.getPaymentType("bonuses").iconName,
                            width: 40,
                            height: 40,
                          ),
                          title: new Text(MainApplication().curOrder.getPaymentType("bonuses").choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.checkedPayment = "bonuses";
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }
}
