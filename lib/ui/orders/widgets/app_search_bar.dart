import 'package:flutter/material.dart';

class AppSearchBar extends AppBar {
  final ValueChanged<String> onChanged;
  final VoidCallback onBackPressed;
  final String hintText;
  final TextEditingController _controller = new TextEditingController();


  AppSearchBar({this.onChanged, this.onBackPressed, this.hintText});


  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: onBackPressed,
      ),
      title: Theme(
        data: ThemeData(hintColor: Colors.transparent),
        child: Container(
          height: 42,
          child: TextField(
            controller: _controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
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
      ),
    );
  }
}
