import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class InputWidget extends StatefulWidget {
  final double topRight;
  final double bottomRight;
  final String type;

  InputWidget(this.topRight, this.bottomRight, this.type);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController maskedTextController;

  String getText(){
    return maskedTextController.text;
  }


  @override
  void initState() {
    super.initState();
    switch (widget.type){
      case "phone": maskedTextController = MaskedTextController(mask: '(000) 000-00-00');break;
      case "code":maskedTextController = MaskedTextController(mask: '0000');break;
      default:
        maskedTextController = TextEditingController();
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(widget.bottomRight), topRight: Radius.circular(widget.topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: maskedTextController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 14,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
