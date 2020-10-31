import 'package:flutter/material.dart';

class RoutePointTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController _controller = new TextEditingController();
  final String hintText;
  final FocusNode focusNode;
  final bool autoFocus;

  RoutePointTextField({Key key, this.hintText,this.onChanged, this.focusNode ,this.autoFocus = false, this.onSubmitted}) : super(key: key);
  String get value {
    return _controller.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autoFocus,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF757575), fontSize: 16),
        prefixIcon: Icon(
          Icons.search,
          color: Color(0xFF757575),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        fillColor: Color(0xFFEEEEEE),
        filled: true,
      ),
    );
  }
}
