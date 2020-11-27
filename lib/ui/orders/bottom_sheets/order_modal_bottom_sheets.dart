import 'package:booking/models/main_application.dart';
import 'package:booking/models/order_wishes.dart';
import 'package:booking/models/payment_type.dart';
import 'package:booking/services/app_blocs.dart';
import 'package:booking/ui/orders/wishes/order_wishes_baby_seats.dart';
import 'package:booking/ui/orders/wishes/order_wishes_driver_note.dart';
import 'package:booking/ui/orders/wishes/order_wishes_switch.dart';
import 'package:booking/ui/orders/wishes/order_wishes_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              // DebugPrint().flog(MainApplication().curOrder.orderTariff);
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: borderRadius, topLeft: borderRadius), color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
                  child: Column(
                    children: [
                      OrderWishesTitle("Пожелания"),
                      OrderWishesDriverNote(value: orderWishes.driverNote, onChanged: (value) => orderWishes.driverNote = value),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            OrderWishesBabySeats(orderBabySeats: orderWishes.orderBabySeats, onChanged: (value) => orderWishes.orderBabySeats = value),
                            OrderWishesSwitch(
                                orderWishesValue: orderWishes.conditioner,
                                caption: "Кондиционер",
                                onChanged: (value) => orderWishes.conditioner = value,
                                viewSwitch: MainApplication().curOrder.orderTariff.wishesConditioner,
                                svgAssets: "assets/icons/ic_wishes_conditioner.svg"),
                            OrderWishesSwitch(
                                orderWishesValue: orderWishes.petTransportation,
                                caption: "Перевозка питомца",
                                onChanged: (value) => orderWishes.petTransportation = value,
                                viewSwitch: MainApplication().curOrder.orderTariff.wishesPetTransportation,
                                svgAssets: "assets/icons/ic_wishes_pet_transportation.svg"),
                            OrderWishesSwitch(
                                orderWishesValue: orderWishes.nonSmokingSalon,
                                caption: "Не курящий салон",
                                onChanged: (value) => orderWishes.nonSmokingSalon = value,
                                viewSwitch: MainApplication().curOrder.orderTariff.wishesNonSmokingSalon,
                                svgAssets: "assets/icons/ic_wishes_non_smoking_salon.svg"),
                          ],
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
      // DebugPrint().flog(orderWishes);
      MainApplication().curOrder.orderWishes = orderWishes;
      MainApplication().curOrder.calcOrder();
      AppBlocs().newOrderWishesController.sink.add(null);
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
                          MainApplication().curOrder.orderWishes.workDate = null;
                          Navigator.of(context).pop();
                        },
                        child: Text("На текущее время"),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          MainApplication().curOrder.orderWishes.workDate = choseDateTime;
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
    ).whenComplete(() => MainApplication().curOrder.calcOrder());
  }

  static orderNotesRes(BuildContext context) async {
    final noteController = TextEditingController();
    await showModalBottomSheet(
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
    );
    return noteController.text;
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

  static Future<String> orderNoteRes(BuildContext context) async {
    final entranceController = TextEditingController();
    final noteController = TextEditingController();
    String note = "";
    await showModalBottomSheet(
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

      if (entranceController.text != "") {
        note = entranceController.text + " подъезд";
      } else if (noteController.text != "") {
        note = noteController.text;
      }

    });
    return note;
  }

  static paymentTypes(BuildContext context) {
    PaymentType cashPaymentType = MainApplication().curOrder.paymentType(type: "cash");
    PaymentType corporationPaymentType = MainApplication().curOrder.paymentType(type: "corporation");
    PaymentType sberbankPaymentType = MainApplication().curOrder.paymentType(type: "sberbank");
    PaymentType bonusesPaymentType = MainApplication().curOrder.paymentType(type: "bonuses");

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              // margin: EdgeInsets.only(left: 8, right: 8),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  cashPaymentType != null
                      ? new ListTileMoreCustomizable(
                          leading: SvgPicture.asset(
                            cashPaymentType.iconName,
                            width: 32,
                            height: 32,
                            color: Colors.deepOrangeAccent,
                          ),
                          title: new Text(cashPaymentType.choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.selectedPaymentType = "cash";
                          },
                        )
                      : Container(),
                  corporationPaymentType != null
                      ? new ListTileMoreCustomizable(
                          leading: SvgPicture.asset(
                            corporationPaymentType.iconName,
                            width: 32,
                            height: 32,
                            color: Colors.deepOrangeAccent,
                          ),
                          title: new Text(corporationPaymentType.choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.selectedPaymentType = "corporation";
                          },
                        )
                      : Container(),
                  sberbankPaymentType != null
                      ? new ListTileMoreCustomizable(
                          leading: SvgPicture.asset(
                            sberbankPaymentType.iconName,
                            width: 32,
                            height: 32,
                            color: Colors.deepOrangeAccent,
                          ),
                          title: new Text(sberbankPaymentType.choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.selectedPaymentType = "sberbank";
                          },
                        )
                      : Container(),
                  bonusesPaymentType != null
                      ? new ListTileMoreCustomizable(
                          leading: SvgPicture.asset(
                            bonusesPaymentType.iconName,
                            width: 32,
                            height: 32,
                            color: Colors.deepOrangeAccent,
                          ),
                          title: new Text(bonusesPaymentType.choseName),
                          onTap: (details) async {
                            Navigator.pop(context);
                            MainApplication().curOrder.selectedPaymentType = "bonuses";
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
