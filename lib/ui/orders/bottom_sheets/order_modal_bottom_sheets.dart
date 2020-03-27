import 'package:booking/models/main_application.dart';
import 'package:booking/models/payment_type.dart';
import 'package:flutter/material.dart';

class OrderModalBottomSheets {
  static orderNote(BuildContext context) {
    showModalBottomSheet(
      context: context,
        isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextField(
                autofocus: true,
                // controller: entranceController,
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
                // controller: noteController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'или к чему подъехать',
                  icon: Icon(
                    Icons.note,
                    color: Color(0xFF757575),
                  ),
                ),
              )
            ],

          ),
        );
      },
    );
  }

  static paymentTypes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: MainApplication().preferences.paymentTypes.length,
            itemBuilder: (BuildContext context, int index) {
              PaymentType paymentType = MainApplication().preferences.paymentTypes[index];
              return ListTile(
                leading: Image.asset(
                  paymentType.iconName,
                  width: 30,
                  height: 30,
                ),
                title: Text(paymentType.choseName),
                onTap: () {
                  MainApplication().curOrder.paymentType = paymentType;
                  Navigator.of(context).pop();
                },
              );
            });
      },
    );
  }

  static paymentTypesEx(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 1,
                minChildSize: 0.95,
                builder: (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        itemCount: MainApplication().preferences.paymentTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          PaymentType paymentType = MainApplication().preferences.paymentTypes[index];
                          print(paymentType.name);
                          return ListTile(
                            leading: Image.asset(
                              paymentType.iconName,
                              width: 30,
                              height: 30,
                            ),
                            title: Text(paymentType.choseName),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
