import 'package:booking/models/order_baby_seats.dart';
import 'package:booking/ui/utils/core.dart';
import 'package:intl/intl.dart';

class OrderWishes {
  String driverNote = "";
  OrderBabySeats orderBabySeats = OrderBabySeats();
  bool petTransportation = false;
  bool nonSmokingSalon = false;
  bool conditioner = false;
  DateTime workDate;

  void clear() {
    driverNote = "";
    orderBabySeats.clear();
    petTransportation = false;
    nonSmokingSalon = false;
    conditioner = false;
    workDate = null;
  }

  int get count{
    int count = 0;
    if (driverNote != ""){count ++;}
    if (orderBabySeats.getCount() > 0){count ++;}
    if (petTransportation){count ++;}
    if (nonSmokingSalon){count ++;}
    if (conditioner){count ++;}
    if (workDate != null){count ++;}
    return count;
  }

  int get countWithOutWorkDate{
    if (count == 0) return 0;
    if (workDate != null)return (count - 1);
    return count;
  }

  String get orderSlidingTitle{
    if (count == 1){
      if (workDate != null){
        return workDateCaption;
      }
    }
    return "";
  }


  String get workDateCaption{
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(workDate.year, workDate.month, workDate.day);
    String date = "";
    if(aDate == today){
      date = "сегодня на " + DateFormat('HH:mm', 'ru').format(workDate);
    }
    else if (aDate == tomorrow){
      date = "завтра на " + DateFormat('HH:mm', 'ru').format(workDate);
    }
    else {
      date = DateFormat('dd MMMM на HH:mm', 'ru').format(workDate);
    }
    return date;
  }

  void parseData(Map<String, dynamic> jsonData) {
    driverNote = jsonData['driver_note'] != null ? jsonData['driver_note'] : "";
    orderBabySeats.parseData(jsonData['baby_seats']);
    petTransportation = MainUtils.parseBool(jsonData['pet_transportation']);
    nonSmokingSalon = MainUtils.parseBool(jsonData['non_smoking_salon']);
    conditioner = MainUtils.parseBool(jsonData['conditioner']);
    workDate = jsonData["work_date"] != null ? DateTime.parse(jsonData["work_date"]) : null;
  }

  Map<String, dynamic> toJson() => {
        "driver_note": driverNote,
        "baby_seats": orderBabySeats,
        "pet_transportation": petTransportation.toString(),
        "non_smoking_salon": nonSmokingSalon.toString(),
        "conditioner": conditioner.toString(),
        "work_date": workDate != null ? workDate.toString() : "",
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
