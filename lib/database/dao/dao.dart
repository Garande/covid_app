import 'package:sqflite/sqflite.dart';

abstract class BaseDao<T> {
  Future<void> createTable(Database database);

  Future<void> dropTable(Database database);

  Future<int> insert(T object);

  Future<int> update(T object);

  Future<int> delete(String id);

  Future<bool> isExist(String id);

  Future<T> fetchSingle({String id, List<String> columns});

  Future<List<T>> fetchAll({List<String> columns, String query});

  Future<int> saveToLocalDb(T object);
}
