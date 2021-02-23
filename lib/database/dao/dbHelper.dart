import 'package:kopesha/database/database.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final databaseProvider = DatabaseProvider.databaseProvider;

  static Future<int> delete({String id, String field, String table}) async {
    final db = await databaseProvider.database;
    var result = await db.delete(table, where: '$field = ?', whereArgs: [id]);
    return result;
  }

  static Future<int> deleteTableRecords(String table) async {
    final db = await databaseProvider.database;
    var result = await db.delete(
      table,
    );
    return result;
  }

  static Future<void> dropTable({Database database, String table}) async {
    await database.execute("DROP TABLE IF EXISTS $table");
    return null;
  }

  static Future<List<Map<String, dynamic>>> fetchAll({
    List<String> columns,
    String query,
    String whereField,
    String table,
    Function createTable,
  }) async {
    final db = await databaseProvider.database;
    if (createTable != null) createTable(db);
    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(table,
            columns: columns,
            where: '$whereField LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(table, columns: columns);
    }
    return result;
  }

  ///fetch data for integer ranges
  static Future<List<Map<String, dynamic>>> fetchAllByIntFieldRange({
    List<String> columns,
    String whereField,
    String table,
    int startValue,
    int endValue,
    Function createTable,
  }) async {
    final db = await databaseProvider.database;
    if (createTable != null) createTable(db);

    List<Map<String, dynamic>> result = [];
    if (startValue != null && endValue != null) {
      String sqlStmt =
          'SELECT * FROM $table WHERE $whereField BETWEEN $startValue AND $endValue';

      result = await db.rawQuery(sqlStmt);
    } else {
      ///Fetch all members\
      result = await db.query(table, columns: columns);
    }

    return result;
  }

  static Future<List<Map<String, dynamic>>> fetchSingle({
    String id,
    List<String> columns,
    String table,
    String whereField,
    Future<void> Function(Database database) createTable,
  }) async {
    final db = await databaseProvider.database;
    if (createTable != null) createTable(db);

    // List<Map<String, dynamic>> result = [];
    return db.query(table,
        columns: columns, where: '$whereField = ?', whereArgs: ["$id"]);
    // return result;
  }

  static Future<int> insert(
      {Map<dynamic, dynamic> object, String table}) async {
    final db = await databaseProvider.database;

    var result = db.insert(table, object);
    return result;
  }

  static Future<bool> isExist({
    String id,
    String table,
    String whereField,
    Future<void> Function(Database database) createTable,
  }) async {
    final db = await databaseProvider.database;
    if (createTable != null) createTable(db);
    List<Map<String, dynamic>> result;
    result =
        await db.query(table, where: '$whereField = ?', whereArgs: ["$id"]);

    // print(result);

    if (result.isNotEmpty && result.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<int> update(
      {Map<String, dynamic> object,
      String table,
      String whereField,
      var whereArg}) async {
    final db = await databaseProvider.database;

    var result = await db
        .update(table, object, where: "$whereField = ?", whereArgs: [whereArg]);
    return result;
  }

  static Future<int> saveToLocalDb({
    String id,
    String table,
    String whereField,
    Map<String, dynamic> object,
    var whereArg,
    Function createTable,
  }) async {
    final db = await databaseProvider.database;
    if (createTable != null) createTable(db);
    bool isExisting =
        await isExist(id: id, table: table, whereField: whereField);

    if (isExisting) {
      return await update(
          object: object,
          table: table,
          whereField: whereField,
          whereArg: whereArg);
    } else {
      return await insert(object: object, table: table);
    }
  }
}
