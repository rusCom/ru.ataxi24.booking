import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class OrderSearchCarBottomSheet extends StatelessWidget {
  final SolidController _controller = SolidController();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity - 16),
      margin: EdgeInsets.only(left: 8, right: 8),
      child: SolidBottomSheet(
        controller: _controller,
        draggableBody: true,
        headerBar: Container(
          color: Colors.amber,
          height: 50,
          child: Center(
            child: Text("Swipe me!"),
          ),
        ),
        body: Container(
          color: Colors.white,
          height: 30,
          child: Center(
            child: Text(
              "Hello! I'm a bottom sheet :D",
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
      ),
    );
  }
}
