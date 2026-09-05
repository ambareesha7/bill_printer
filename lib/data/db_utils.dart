import 'dart:convert';

import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/print_settings_model.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/v7.dart';

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
  // ======================== Product CRUD operations =====================
  Future<void> insertProduct({
    required String name,
    required String price,
    int priority = 1,
  }) async {
    final productCompanion = ProductsCompanion.insert(
      name: name,
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      price: price,
      priority: priority,
    );
    try {
      await db.into(db.products).insert(productCompanion);
    } catch (e) {
      debugLog("Error inserting product: $e");
    }
  }

  Future<void> updateProduct({
    required int id,
    String? name,
    String? price,
    int? priority,
  }) async {
    final productCompanion = ProductsCompanion(
      id: Value(id),
      name: name != null ? Value(name) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
      price: price != null ? Value(price) : const Value.absent(),
      priority: priority != null ? Value(priority) : const Value.absent(),
    );
    try {
      await db.update(db.products).replace(productCompanion);
    } catch (e) {
      debugLog("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await (db.delete(db.products)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      debugLog("Error deleting product: $e");
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      return await db.select(db.products).get();
    } catch (e) {
      debugLog("Error fetching products: $e");
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
      debugLog("Error inserting bankAccounts: $e");
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
      debugLog("Error updating bankAccounts: $e");
    }
  }

  Future<void> deleteBankAccounts(int id) async {
    try {
      await (db.delete(
        db.bankAccounts,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      debugLog("Error deleting bankAccounts: $e");
    }
  }

  Future<List<BankAccount>> getBankAccounts() async {
    try {
      return await db.select(db.bankAccounts).get();
    } catch (e) {
      debugLog("Error fetching bankAccounts: $e");
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
      debugLog("Error fetching account by UPI ID: $e");
      return [];
    }
  }

  // ======================== SaleReceipts CRUD operations =====================
  Future<void> insertSaleReceipt({
    required List<BillItemModel> billItems,
    required int totalAmount,
    required String orderNo,
    String? customerName,
    String? preparedBy,
    String? paymentMode,
    String? paymentStatus,
    String? paymentRef,
  }) async {
    final saleReceipt = SaleReceiptsCompanion.insert(
      id: UuidV7().generate(),
      billItems: jsonEncode(billItems),
      totalAmount: totalAmount,
      customerName: Value(customerName),
      preparedBy: Value(preparedBy),
      orderNo: orderNo,
      paymentMode: paymentMode == null
          ? Value(PaymentMode.cash.name)
          : Value(paymentMode),
      paymentStatus: paymentStatus == null
          ? Value(PaymentStatus.receivable.name)
          : Value(paymentStatus),
      paymentRef: Value(paymentRef),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
    // debugLog(saleReceipt, tag: "saleReceipts");
    try {
      await db.into(db.saleReceipts).insert(saleReceipt);
    } catch (e) {
      debugLog("Error inserting saleReceipt: $e");
    }
  }

  Future<bool> insertAllReceipts({required List<SaleReceipt> receipts}) async {
    try {
      await db.batch((batch) {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        batch.insertAll(
          db.saleReceipts,
          List.generate(receipts.length, (index) {
            final i = receipts[index];
            return SaleReceiptsCompanion.insert(
              id: i.id,
              billItems: i.billItems,
              totalAmount: i.totalAmount,
              customerName: Value(i.customerName),
              preparedBy: Value(i.preparedBy),
              orderNo: i.orderNo,
              paymentMode: Value(i.paymentMode),
              paymentStatus: Value(i.paymentStatus),
              paymentRef: Value(i.paymentRef),
              createdAt: Value(i.createdAt),
              updatedAt: Value(i.updatedAt),
            );
          }),
        );
      });
      return true;
    } catch (e, st) {
      debugLog(e, tag: "Error in insertAllReceipts");
      debugLog(st, tag: "Stack");
      return false;
    }
  }

  Future<void> updateSaleReceipt({
    required SaleReceiptModel saleReceipt,
  }) async {
    final saleRec = SaleReceiptsCompanion(
      id: Value(saleReceipt.id!),
      billItems: saleReceipt.billItems != null
          ? Value(jsonEncode(saleReceipt.billItems))
          : const Value.absent(),
      totalAmount: saleReceipt.totalAmount != null
          ? Value(saleReceipt.totalAmount!)
          : const Value.absent(),
      customerName: saleReceipt.customerName != null
          ? Value(saleReceipt.customerName)
          : const Value.absent(),
      preparedBy: saleReceipt.preparedBy != null
          ? Value(saleReceipt.preparedBy)
          : const Value.absent(),
      paymentMode: saleReceipt.paymentMode == null
          ? Value("cash")
          : Value(saleReceipt.paymentMode!),
      paymentStatus: Value(saleReceipt.paymentStatus.name),
      orderNo: Value(saleReceipt.orderNo ?? "0"),
      paymentRef: saleReceipt.paymentRef != null
          ? Value(saleReceipt.paymentRef)
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    try {
      await db.update(db.saleReceipts).replace(saleRec);
    } catch (e) {
      debugLog("Error updating saleReceipt: $e");
    }
  }

  Future<void> deleteSaleReceipt(String id) async {
    try {
      await (db.delete(
        db.saleReceipts,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      debugLog("Error deleting saleReceipt: $e");
    }
  }

  Future<List<SaleReceipt>> getAllSaleReceipts() async {
    try {
      return await db.select(db.saleReceipts).get();
    } catch (e) {
      debugLog("Error fetching getSaleReceipts: $e");
      return [];
    }
  }

  Future<List<SaleReceiptModel>> getNParseSaleReceipts() async {
    List<SaleReceipt> saleReceipts = await getAllSaleReceipts();
    return parseSaleReceipts(saleReceipts);
  }

  List<SaleReceiptModel> parseSaleReceipts(List<SaleReceipt> saleReceipts) {
    return saleReceipts
        .map(
          (b) => SaleReceiptModel(
            id: b.id,
            customerName: b.customerName,
            preparedBy: b.preparedBy,
            billItems: parseBillsFromJson(b.billItems),
            totalAmount: b.totalAmount,
            paymentMode: b.paymentMode,
            paymentStatus: PaymentStatus.values.firstWhere(
              (e) => e.name == b.paymentStatus,
            ),
            paymentRef: b.paymentRef,
            orderNo: b.orderNo,
            createdAt: b.createdAt,
            updatedAt: b.updatedAt,
          ),
        )
        .toList();
  }

  List<BillItemModel> parseBillsFromJson(String billItems) {
    if (billItems.isEmpty) return [];
    List decodedItems = jsonDecode(billItems);
    return decodedItems.map((i) => BillItemModel.fromJson(i)).toList();
  }

  Future<List<SaleReceiptModel>> getNParseReport({
    required DateTime startDate,
    required DateTime lastDate,
  }) async {
    List<SaleReceipt> saleReceipts = await getSaleReportFromDB(
      startDate: startDate,
      lastDate: lastDate,
    );
    return parseSaleReceipts(saleReceipts);
  }

  Future<List<SaleReceipt>> getSaleReportFromDB({
    required DateTime startDate,
    required DateTime lastDate,
  }) async {
    try {
      // Use the exact times provided by the date/time picker
      return await (db.select(
            db.saleReceipts,
          )..where((tbl) => tbl.createdAt.isBetweenValues(startDate, lastDate)))
          .get();
    } catch (e) {
      debugLog("Error getSaleReportFromDB: $e");
      return [];
    }
  }

  Future<SaleReceipt?> getLastBillFromDB() async {
    try {
      final query = db.select(db.saleReceipts)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(1);

      return await query.getSingleOrNull();
    } catch (e) {
      debugLog("Error getLastBillFromDB: $e");
      return null;
    }
  }


  // ======================== Print settings CRUD operations =====================
  Future<PrintSetting?> getPrintSettings() async {
    try {
      return await (db.select(db.printSettings)
            ..orderBy([(table) => OrderingTerm.asc(table.id)])
            ..limit(1))
          .getSingleOrNull();
    } catch (e) {
      debugLog("Error in getPrintSettings: $e");
      return null;
    }
  }

  Future<void> insertPrintSettings({
    required PrintSettingsModel settings,
  }) async {
    try {
      await db
          .into(db.printSettings)
          .insert(
            PrintSettingsCompanion.insert(
              businessName: Value(settings.businessName),
              placeAddress: Value(settings.placeAddress),
              headerText1: Value(settings.headerText1),
              headerText2: Value(settings.headerText2),
              gstNo: Value(settings.gstNo),
              invoiceTitle: Value(settings.invoiceTitle),
              footerText1: Value(settings.footerText1),
              footerText2: Value(settings.footerText2),
              createdAt: settings.createdAt ?? DateTime.now(),
              updatedAt: settings.updatedAt ?? DateTime.now(),
            ),
          );
    } catch (e) {
      debugLog("Error insertPrintSettings: $e");
    }
  }

  Future<void> updatePrintSettings({
    required PrintSettingsModel settings,
  }) async {
    if (settings.id == null) return;
    try {
      await db
          .update(db.printSettings)
          .replace(
            PrintSettingsCompanion(
              id: Value(settings.id!),
              businessName: Value(settings.businessName),
              placeAddress: Value(settings.placeAddress),
              headerText1: Value(settings.headerText1),
              headerText2: Value(settings.headerText2),
              gstNo: Value(settings.gstNo),
              invoiceTitle: Value(settings.invoiceTitle),
              footerText1: Value(settings.footerText1),
              footerText2: Value(settings.footerText2),
              createdAt: Value(settings.createdAt ?? DateTime.now()),
              updatedAt: Value(settings.updatedAt ?? DateTime.now()),
            ),
          );
    } catch (e) {
      debugLog("Error in updatePrintSettings: $e");
    }
  }

  Future<void> deletePrintSettings() async {
    try {
      await db.delete(db.printSettings).go();
    } catch (e) {
      debugLog("Error in deletePrintSettings: $e");
    }
  }

  PrintSettingsModel printSettingsToModel(PrintSetting settings) {
    return PrintSettingsModel(
      id: settings.id,
      businessName: settings.businessName,
      placeAddress: settings.placeAddress,
      headerText1: settings.headerText1,
      headerText2: settings.headerText2,
      gstNo: settings.gstNo,
      invoiceTitle: settings.invoiceTitle,
      footerText1: settings.footerText1,
      footerText2: settings.footerText2,
      createdAt: settings.createdAt,
      updatedAt: settings.updatedAt,
    );
  }
}
