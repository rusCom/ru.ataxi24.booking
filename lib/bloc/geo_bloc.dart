import 'dart:async';

import 'package:booking/services/geo_service.dart';
import 'package:flutter/material.dart';

class GeoAutocompleteBloc {
  var _geoBlocController = StreamController();

  Stream get geoBlocStream => _geoBlocController.stream;

  void autocomplete(BuildContext context, String keyword) {
    if (keyword.isNotEmpty) {
      _geoBlocController.sink.add("searching_");
      GeoService().autocomplete(keyword).then((result) {
        _geoBlocController.sink.add(result);
      }).catchError((e) {});
    }
    else {
      _geoBlocController.add("null_");
    }
  }
}
