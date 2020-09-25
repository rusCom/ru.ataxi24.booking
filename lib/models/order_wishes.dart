import 'package:booking/models/order_baby_seats.dart';

class OrderWishes{
  String driverNote = "";
  OrderBabySeats orderBabySeats = OrderBabySeats();


  void clear(){
    driverNote = "";
    orderBabySeats.clear();
  }



  Map<String, dynamic> toJson() => {
    "driver_note": driverNote,
    "baby_seats": orderBabySeats,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}