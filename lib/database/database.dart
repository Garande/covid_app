import 'dart:io';
import 'dart:async';

import 'package:covid_app/database/dao/userDao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider databaseProvider = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase(); //If null initialize database;
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "mLearning.db");

    var database = await openDatabase(path,
        version: 1, onCreate: onCreate, onUpgrade: onUpgrade);

    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      //dropTables
      UserDao().dropTable(database);

      onCreate(database, newVersion);
    }
  }

  void onCreate(Database database, int version) async {
    //create tables
    UserDao().createTable(database);
    // StudentDao().createTable(database);
  }
}
