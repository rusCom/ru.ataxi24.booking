import 'package:flutter/material.dart';

class RoutePointSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController _controller = new TextEditingController();

  RoutePointSearchBar({this.onChanged}): super();

  void setText(String data){
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      _controller.text = data + " ";
        _controller.selection = new TextSelection.fromPosition(
        new TextPosition(offset: _controller.text.length));

    });
    onChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(hintColor: Colors.transparent),
      child: Container(
        height: 42,
        child: TextField(
          controller: _controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "search",
            hintStyle: TextStyle(color: Color(0xFF757575), fontSize: 16),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF757575),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Color(0xFF757575),
              ),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
                onChanged("");
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            fillColor: Color(0xFFEEEEEE),
            filled: true,
          ),
        ),
      ),
    );
  }
}
