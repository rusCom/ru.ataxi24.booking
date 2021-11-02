import 'package:booking/models/preferences.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:flutter/material.dart';

class OrderBabySeats {
  final String TAG = (OrderBabySeats).toString(); // ignore: non_constant_identifier_names
  int _babySeat0010 = 0;
  int _babySeat0918 = 0;
  int _babySeat1525 = 0;
  int _babySeat2236 = 0;

  int _maxBabySeats = Preferences().wishesBabySeatsCount;

  Text get subtitle {
    if (_babySeat0010 == 2) {
      return Text("Две люльки до 10 кг");
    }
    if (_babySeat0918 == 2) {
      return Text("Два кресла от 9 до 18 кг");
    }
    if (_babySeat1525 == 2) {
      return Text("Два кресла от 15 до 25 кг");
    }
    if (_babySeat2236 == 2) {
      return Text("Два бустера от 22 до 36 кг");
    }

    if (getCount() == 1) {
      if (_babySeat0010 == 1) {
        return Text("Люлька до 10 кг");
      }
      if (_babySeat0918 == 1) {
        return Text("Кресло от 9 до 18 кг");
      }
      if (_babySeat1525 == 1) {
        return Text("Кресло от 15 до 25 кг");
      }
      if (_babySeat2236 == 1) {
        return Text("Бустер от 22 до 36 кг");
      }
    }

    String res = "";
    if (_babySeat0010 == 1) {
      res = "Люлька до 10 кг и ";
      if (_babySeat0918 == 1) {
        res = res + "кресло от 9 до 18 кг";
      }
      if (_babySeat1525 == 1) {
        res = res + "кресло от 15 до 25 кг";
      }
      if (_babySeat2236 == 1) {
        res = res + "бустер от 22 до 36 кг";
      }
      return Text(res);
    }

    if (_babySeat2236 == 1) {
      if (_babySeat0918 == 1) {
        res = "Кресло от 9 до 18 кг";
      }
      if (_babySeat1525 == 1) {
        res = "Кресло от 15 до 25 кг";
      }
      res = res + " и бустер от 22 до 36 кг";
      return Text(res);
    }

    if (getCount() == 2) {
      return Text("Два кресла от 9 до 18 и от 15 до 25 кг");
    }

    return null;
  }

  void clear() {
    _babySeat0010 = 0;
    _babySeat0918 = 0;
    _babySeat1525 = 0;
    _babySeat2236 = 0;
  }

  bool get isClearButton {
    if (getCount() == 0) return false;
    return true;
  }

  set babySeat0010(value) {
    _babySeat0010 = value;
    // Если возможно выбрать только одно кресло
    if (_maxBabySeats == 1){
      _babySeat0918 = 0;
      _babySeat1525 = 0;
      _babySeat2236 = 0;
    }
    // Если возможно выбрать два кресла
    if (_maxBabySeats == 2) {
      if (getCount() > 2) {
        if (_babySeat0010 == 2) {
          _babySeat0918 = 0;
          _babySeat1525 = 0;
          _babySeat2236 = 0;
        } else {
          if (_babySeat0918 == 2) {
            _babySeat0918 = 1;
          }
          if (_babySeat1525 == 2) {
            _babySeat1525 = 1;
          }
          if (_babySeat2236 == 2) {
            _babySeat2236 = 1;
          }
          if ((getCount() > 2) && (_babySeat0918 == 1)) {
            _babySeat0918 = 0;
          }
          if ((getCount() > 2) && (_babySeat1525 == 1)) {
            _babySeat1525 = 0;
          }
          if ((getCount() > 2) && (_babySeat2236 == 1)) {
            _babySeat2236 = 0;
          }
        }
      }
    }
  }

  set babySeat0918(value) {
    _babySeat0918 = value;
    // Если возможно выбрать только одно кресло
    if (_maxBabySeats == 1){
      _babySeat0010 = 0;
      _babySeat1525 = 0;
      _babySeat2236 = 0;
    }
    // Если возможно выбрать два кресла
    if (_maxBabySeats == 2) {
      if (getCount() > 2) {
        if (_babySeat0918 == 2) {
          _babySeat0010 = 0;
          _babySeat1525 = 0;
          _babySeat2236 = 0;
        } else {
          if (_babySeat0010 == 2) {
            _babySeat0010 = 1;
          }
          if (_babySeat1525 == 2) {
            _babySeat1525 = 1;
          }
          if (_babySeat2236 == 2) {
            _babySeat2236 = 1;
          }
          if ((getCount() > 2) && (_babySeat0010 == 1)) {
            _babySeat0010 = 0;
          }
          if ((getCount() > 2) && (_babySeat1525 == 1)) {
            _babySeat1525 = 0;
          }
          if ((getCount() > 2) && (_babySeat2236 == 1)) {
            _babySeat2236 = 0;
          }
        }
      }
    }
  }

  set babySeat1525(value) {
    _babySeat1525 = value;
    // Если возможно выбрать только одно кресло
    if (_maxBabySeats == 1){
      _babySeat0010 = 0;
      _babySeat0918 = 0;
      _babySeat2236 = 0;
    }
    // Если возможно выбрать два кресла
    if (_maxBabySeats == 2) {
      if (getCount() > 2) {
        if (_babySeat1525 == 2) {
          _babySeat0010 = 0;
          _babySeat0918 = 0;
          _babySeat2236 = 0;
        } else {
          if (_babySeat0010 == 2) {
            _babySeat0010 = 1;
          }
          if (_babySeat0918 == 2) {
            _babySeat0918 = 1;
          }
          if (_babySeat2236 == 2) {
            _babySeat2236 = 1;
          }
          if ((getCount() > 2) && (_babySeat0010 == 1)) {
            _babySeat0010 = 0;
          }
          if ((getCount() > 2) && (_babySeat0918 == 1)) {
            _babySeat0918 = 0;
          }
          if ((getCount() > 2) && (_babySeat2236 == 1)) {
            _babySeat2236 = 0;
          }
        }
      }
    }
  }

  set babySeat2236(value) {
    _babySeat2236 = value;
    // Если возможно выбрать только одно кресло
    if (_maxBabySeats == 1){
      _babySeat0010 = 0;
      _babySeat0918 = 0;
      _babySeat1525 = 0;
    }
    // Если возможно выбрать два кресла
    if (_maxBabySeats == 2) {
      if (getCount() > 2) {
        if (_babySeat2236 == 2) {
          _babySeat0010 = 0;
          _babySeat0918 = 0;
          _babySeat1525 = 0;
        } else {
          if (_babySeat0010 == 2) {
            _babySeat0010 = 1;
          }
          if (_babySeat0918 == 2) {
            _babySeat0918 = 1;
          }
          if (_babySeat1525 == 2) {
            _babySeat1525 = 1;
          }
          if ((getCount() > 2) && (_babySeat0010 == 1)) {
            _babySeat0010 = 0;
          }
          if ((getCount() > 2) && (_babySeat0918 == 1)) {
            _babySeat0918 = 0;
          }
          if ((getCount() > 2) && (_babySeat1525 == 1)) {
            _babySeat1525 = 0;
          }
        }
      }
    }
  }

  int getCount() {
    return _babySeat0010 + _babySeat0918 + _babySeat1525 + _babySeat2236;
  }

  int get babySeat0010 => _babySeat0010;

  int get babySeat0918 => _babySeat0918;

  int get babySeat1525 => _babySeat1525;

  int get babySeat2236 => _babySeat2236;

  void parseData(Map<String, dynamic> jsonData) {
    if (jsonData == null) {
      _babySeat0010 = 0;
      _babySeat0918 = 0;
      _babySeat1525 = 0;
      _babySeat2236 = 0;
    } else {
      _babySeat0010 = MainUtils.parseInt(jsonData['0010']);
      _babySeat0918 = MainUtils.parseInt(jsonData['0918']);
      _babySeat1525 = MainUtils.parseInt(jsonData['1525']);
      _babySeat2236 = MainUtils.parseInt(jsonData['2236']);
    }
  }

  Map<String, dynamic> toJson() => {
        "0010": babySeat0010,
        "0918": babySeat0918,
        "1525": babySeat1525,
        "2236": babySeat2236,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
