import 'dart:async';

import 'package:booking/ui/utils/core.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _database;

  static Future<void> init() async {
    if (_database != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _database = await openDatabase(_path, version: Const.dbVersion, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    if (Const.dbVersion == 1){
      await db.execute('CREATE TABLE todo_items (id INTEGER PRIMARY KEY NOT NULL, task STRING, complete BOOLEAN)');
    }

  }

}
