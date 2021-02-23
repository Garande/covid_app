import 'package:covid_app/database/dao/dao.dart';
import 'package:covid_app/database/dao/dbHelper.dart';
import 'package:covid_app/database/database.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:sqflite_common/sqlite_api.dart';

class UserDao extends BaseDao<AppUser> {
  String _tableName = "users";

  String _userIdField = "userId";
  String _nameField = "name";
  String _emailField = "email";
  String _photoUrlField = "photoUrl";
  String _loginIdField = "loginId";
  String _phoneField = "phoneNumber";
  String _countryCodeField = "countryCode";
  String _dobField = "dob";
  String _genderField = "gender";
  String _pushTokenField = "pushToken";
  String _roleField = "role";
  String _statusField = "status";

  final databaseProvider = DatabaseProvider.databaseProvider;

  @override
  Future<void> createTable(Database database) async {
    await database.execute("CREATE TABLE IF NOT EXISTS $_tableName ("
        "$_userIdField TEXT PRIMARY KEY, "
        "$_nameField TEXT, "
        "$_emailField TEXT, "
        "$_photoUrlField TEXT, "
        "$_loginIdField TEXT, "
        "$_phoneField TEXT, "
        "$_countryCodeField TEXT, "
        "$_dobField TEXT, "
        "$_genderField TEXT, "
        "$_pushTokenField TEXT, "
        "$_roleField TEXT, "
        "$_statusField TEXT "
        ")");
    return null;
  }

  @override
  Future<int> delete(String id) async {
    final db = await databaseProvider.database;
    var result = await db
        .delete(_tableName, where: '$_userIdField = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteTableRecords() async {
    final db = await databaseProvider.database;
    var result = await db.delete(
      _tableName,
    );
    return result;
  }

  @override
  Future<void> dropTable(Database database) async {
    await database.execute("DROP TABLE IF EXISTS $_tableName");
    return null;
  }

  @override
  Future<List<AppUser>> fetchAll({List<String> columns, String query}) async {
    final db = await databaseProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(_tableName,
            columns: columns,
            where: '$_nameField LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(_tableName, columns: columns);
    }

    List<AppUser> users = result.isNotEmpty
        ? result.map((user) => AppUser.fromJson(user)).toList()
        : [];
    return users;
  }

  @override
  Future<AppUser> fetchSingle({String id, List<String> columns}) async {
    final db = await databaseProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(_tableName,
        columns: columns, where: '$_userIdField = ?', whereArgs: ["$id"]);

    List<AppUser> users = result.isNotEmpty
        ? result.map((user) => AppUser.fromJson(user)).toList()
        : [];
    return users[0];
  }

  Future<AppUser> fetchUserByLogInId(
      {String loginId, List<String> columns}) async {
    final db = await databaseProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(_tableName,
        columns: columns, where: '$_loginIdField = ?', whereArgs: ["$loginId"]);

    List<AppUser> users = result.isNotEmpty
        ? result.map((user) => AppUser.fromJson(user)).toList()
        : [];
    if (users.length > 0) {
      return users[0];
    }
    return null;
  }

  @override
  Future<int> insert(AppUser object) async {
    final db = await databaseProvider.database;
    var result = db.insert(_tableName, object.toJson());
    return result;
  }

  @override
  Future<bool> isExist(String id) async {
    final db = await databaseProvider.database;

    List<Map<String, dynamic>> result;
    result = await db
        .query(_tableName, where: '$_userIdField = ?', whereArgs: ["$id"]);

    if (result.isNotEmpty && result.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<int> update(AppUser object) async {
    final db = await databaseProvider.database;

    var result = await db.update(_tableName, object.toJson(),
        where: "$_userIdField = ?", whereArgs: [object.userId]);
    return result;
  }

  Future<bool> isUserExistByLoginId(String loginId) async {
    final db = await databaseProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(_tableName,
        where: '$_loginIdField = ?', whereArgs: ["$loginId"]);

    if (result.isNotEmpty && result.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<int> saveToLocalDb(AppUser object) {
    return DBHelper.saveToLocalDb(
      id: object.userId,
      table: _tableName,
      whereField: _userIdField,
      whereArg: object.userId,
      object: object.toJson(),
      createTable: createTable,
    );
  }
}
