import 'package:bill_printer/core/database.dart';
import 'package:drift/drift.dart';

class DBUtils {
  DBUtils._internal();

  static DBUtils get instance => _instance;
  static final DBUtils _instance = DBUtils._internal();
  static AppDatabase? _db;

  // Lazily initialise and return the single AppDatabase instance.
  static AppDatabase get db {
    _db ??= AppDatabase();
    return _db!;
  }

  // Close and dispose the database instance. Call when app is terminating if needed.
  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<void> insertCategory({required String name}) async {
    final categoryCompanion = CategoriesCompanion(
      name: Value(name),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    try {
      await db.into(db.categories).insert(categoryCompanion);
    } catch (e) {
      print("Error inserting category: $e");
    }
  }

  Future<void> updateCategory(int id, String name) async {
    final categoryCompanion = CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      updatedAt: Value(DateTime.now()),
    );
    await db.update(db.categories).replace(categoryCompanion);
  }

  Future<void> deleteCategory(int id) async {
    await (db.delete(db.categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Category>> getCategories() async {
    return await db.select(db.categories).get();
  }
}
