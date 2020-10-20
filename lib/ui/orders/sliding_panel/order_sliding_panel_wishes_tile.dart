import 'package:booking/models/order_wishes.dart';
import 'package:booking/ui/orders/wishes/order_wishes_title.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderSlidingPanelWishesTile extends StatelessWidget {
  final OrderWishes orderWishes;

  OrderSlidingPanelWishesTile(this.orderWishes);

  @override
  Widget build(BuildContext context) {
    if (orderWishes.count > 1) {
      return ListTile(
        leading: SvgPicture.asset(
          "assets/icons/ic_wishes.svg",
          height: Const.modalBottomSheetsLeadingSize,
          width: Const.modalBottomSheetsLeadingSize,
        ),
        title: Text("Пожелания к заказу"),
        trailing: ClipOval(
          child: Container(
            color: Colors.amberAccent,
            height: 24,
            width: 24,
            child: Center(
              child: Text(orderWishes.count.toString()),
            ),
          ),
        ),
        onTap: () => viewModalBottomSheet(context),
      );
    }

    if ((orderWishes.count == 1) & (orderWishes.orderBabySeats.getCount() > 0)) {
      return _orderBabySeats();
    }

    if ((orderWishes.count == 1) & (orderWishes.nonSmokingSalon)) {
      return _nonSmokingSalon();
    }

    if ((orderWishes.count == 1) & (orderWishes.petTransportation)) {
      return _petTransportation();
    }

    if ((orderWishes.count == 1) & (orderWishes.conditioner)) {
      return _conditioner();
    }

    if ((orderWishes.count == 1) & (orderWishes.driverNote != "")) {
      return _driverNote();
    }

    if ((orderWishes.count == 1) & (orderWishes.workDate != null)) {
      return _workDate();
    }

    return Container();
  }

  void viewModalBottomSheet(BuildContext context) {
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
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Const.modalBottomSheetsBorderRadius, topLeft: Const.modalBottomSheetsBorderRadius), color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 8, right: 8, top: 16),
                  child: Column(
                    children: [
                      OrderWishesTitle("Пожелания"),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            _workDate(),
                            _driverNote(),
                            _orderBabySeats(),
                            _nonSmokingSalon(),
                            _conditioner(),
                            _petTransportation(),
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
    );
  }

  //

  Widget _petTransportation() {
    if (!orderWishes.petTransportation) return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_pet_transportation.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: Text("Перевозка питомца"),
    );
  }

  Widget _conditioner() {
    if (!orderWishes.conditioner) return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_conditioner.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: Text("Кондиционер"),
    );
  }

  Widget _nonSmokingSalon() {
    if (!orderWishes.nonSmokingSalon) return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_non_smoking_salon.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: Text("Не курящий салон"),
    );
  }

  Widget _orderBabySeats() {
    if (orderWishes.orderBabySeats.getCount() == 0) return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_baby_seats.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: orderWishes.orderBabySeats.subtitle,
    );
  }

  Widget _driverNote() {
    if (orderWishes.driverNote == "") return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_driver_note.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),

      title: Text(orderWishes.driverNote),
      // subtitle: Text(),
    );
  }

  Widget _workDate() {
    if (orderWishes.workDate == null) return Container();
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_work_date.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: Text("Запланированная поездка"),
      subtitle: Text(orderWishes.workDateCaption),
    );
  }
}
