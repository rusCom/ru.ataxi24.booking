import 'package:booking/models/preferences.dart';
import 'package:booking/ui/orders/wishes/order_wishes_title.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef void OrderWishesDriverNoteChangeCallback(String value);

class OrderWishesDriverNote extends StatefulWidget {
  final String value;
  final OrderWishesDriverNoteChangeCallback onChanged;

  const OrderWishesDriverNote({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  _OrderWishesDriverNoteState createState() => _OrderWishesDriverNoteState();
}

class _OrderWishesDriverNoteState extends State<OrderWishesDriverNote> {
  String value;

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      value = widget.value;
    }
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/ic_wishes_driver_note.svg",
        height: Const.modalBottomSheetsLeadingSize,
        width: Const.modalBottomSheetsLeadingSize,
      ),
      title: value == "" ? Text("Комментарий водителю") : Text(value),
      subtitle: value == "" ? null : Text("Комментарий водителю"),
      onTap: () async {
        String newValue = await orderWishesDriverNote(context, value);
        setState(() {
          if (widget.onChanged != null) {
            widget.onChanged(newValue);
          }
          value = newValue;
        });
      },
      trailing: IconButton(
        icon: Icon(value == "" ? Icons.keyboard_arrow_right : Icons.clear),
        onPressed: () async {
          if (value == "") {
            String newValue = await orderWishesDriverNote(context, value);
            setState(() {
              if (widget.onChanged != null) {
                widget.onChanged(newValue);
              }
              value = newValue;
            });
          } else {
            setState(() {
              if (widget.onChanged != null) {
                widget.onChanged("");
              }
              value = "";
            });
          }
        },
      ),
    );
  }

  static Future<String> orderWishesDriverNote(BuildContext context, String driverNote) async {
    final noteController = TextEditingController(text: driverNote);
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
              // bottomSheetTitle(context, "Комментарий водителю"),
              OrderWishesTitle("Комментарий водителю"),
              TextField(
                autofocus: true,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                },
                controller: noteController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ваш комментарий для водителя',
                  icon: SvgPicture.asset(
                    "assets/icons/ic_wishes_driver_note.svg",
                    height: Const.modalBottomSheetsLeadingSize,
                    width: Const.modalBottomSheetsLeadingSize,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: Colors.yellow[200],
                  textColor: Colors.white,
                  color: Preferences().mainColor,
                  disabledColor: Colors.grey,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Готово",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        );
      },
    );
    return noteController.value.text;
  }
}
