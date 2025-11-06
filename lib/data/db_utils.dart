import 'package:bill_printer/data/database.dart';
import 'package:drift/drift.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/bank_account/bank_account_model.dart';

final dbUtilsProvider = Provider<DBUtils>((ref) {
  return DBUtils.instance;
});

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

  /// USE FOR DEBUGGING PURPOSES ONLY
  ///
  /// deletes all tables and recreates them
  /// USE WITH CAUTION - this will delete all data in the database
  Future<void> reCreateDB() async => await db.reCreateDB();

  // ======================== Category CRUD operations =====================
  Future<void> insertCategory({required String name}) async {
    final categoryCompanion = CategoriesCompanion.insert(
      name: name,
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    try {
      await db.into(db.categories).insert(categoryCompanion);
    } catch (e) {
      debugPrint("Error inserting category: $e");
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

  // ======================== Product CRUD operations =====================
  Future<void> insertProduct({
    required String name,
    required int categoryId,
    required String price,
    int priority = 1,
  }) async {
    final productCompanion = ProductsCompanion.insert(
      name: name,
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      categoryId: categoryId,
      price: price,
      priority: priority,
    );
    try {
      await db.into(db.products).insert(productCompanion);
    } catch (e) {
      debugPrint("Error inserting product: $e");
    }
  }

  Future<void> updateProduct({
    required int id,
    String? name,
    int? categoryId,
    String? price,
    int? priority,
  }) async {
    final productCompanion = ProductsCompanion(
      id: Value(id),
      name: name != null ? Value(name) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      price: price != null ? Value(price) : const Value.absent(),
      priority: priority != null ? Value(priority) : const Value.absent(),
    );
    try {
      await db.update(db.products).replace(productCompanion);
    } catch (e) {
      debugPrint("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await (db.delete(db.products)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      debugPrint("Error deleting product: $e");
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      return await db.select(db.products).get();
    } catch (e) {
      debugPrint("Error fetching products: $e");
      return [];
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      return await (db.select(
        db.products,
      )..where((tbl) => tbl.categoryId.equals(categoryId))).get();
    } catch (e) {
      debugPrint("Error fetching products by category: $e");
      return [];
    }
  }

  // ======================== BankAccount CRUD operations =====================
  Future<void> insertBankAccount({
    required String name,
    required String upiId,
    int? accountNo,
    String? ifsc,
    String? note,
    bool? isPrime,
  }) async {
    final bankAccountCompanion = BankAccountsCompanion.insert(
      name: name,
      upiId: upiId,
      accountNumber: Value(accountNo),
      ifsc: Value(ifsc),
      note: Value(note),
      isPrime: Value(isPrime ?? false),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    try {
      await db.into(db.bankAccounts).insert(bankAccountCompanion);
    } catch (e) {
      debugPrint("Error inserting bankAccounts: $e");
    }
  }

  Future<void> updateBankAccount({
    required int id,
    String? name,
    int? accountNo,
    String? upiId,
    String? ifsc,
    String? note,
    bool? isPrime,
  }) async {
    final bankAccountCompanion = BankAccountsCompanion(
      id: Value(id),
      name: name != null ? Value(name) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      accountNumber: accountNo != null
          ? Value(accountNo)
          : const Value.absent(),
      upiId: upiId != null ? Value(upiId) : const Value.absent(),
      ifsc: ifsc != null ? Value(ifsc) : const Value.absent(),
      note: note != null ? Value(note) : const Value.absent(),
      isPrime: Value(isPrime ?? false),
    );
    try {
      await db.update(db.bankAccounts).replace(bankAccountCompanion);
    } catch (e) {
      debugPrint("Error updating bankAccounts: $e");
    }
  }

  Future<void> deleteBankAccounts(int id) async {
    try {
      await (db.delete(
        db.bankAccounts,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      debugPrint("Error deleting bankAccounts: $e");
    }
  }

  Future<List<BankAccount>> getBankAccounts() async {
    try {
      return await db.select(db.bankAccounts).get();
    } catch (e) {
      debugPrint("Error fetching bankAccounts: $e");
      return [];
    }
  }

  Future<List<BankAccountModel>> parseBankAccounts() async {
    List<BankAccount> accounts = await getBankAccounts();
    return accounts
        .map(
          (b) => BankAccountModel(
            id: b.id,
            name: b.name,
            upiId: b.upiId,
            accountNumber: b.accountNumber,
            ifsc: b.ifsc,
            note: b.note,
            isPrime: b.isPrime,
            createdAt: b.createdAt,
            updatedAt: b.updatedAt,
          ),
        )
        .toList();
  }

  Future<List<BankAccount>> getBankAccountByUpiID(String upi) async {
    try {
      return await (db.select(
        db.bankAccounts,
      )..where((tbl) => tbl.upiId.equals(upi))).get();
    } catch (e) {
      debugPrint("Error fetching account by UPI ID: $e");
      return [];
    }
  }
}
