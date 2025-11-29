import 'package:bill_printer/data/tables/bank_accounts.dart';
import 'package:bill_printer/data/tables/categories_table.dart';
import 'package:bill_printer/data/tables/products_table.dart';
import 'package:bill_printer/data/tables/sale_receipts.dart';
import 'package:bill_printer/data/tables/users.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

@DriftDatabase(
  tables: [Categories, Products, BankAccounts, SaleReceipts, Users],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// USE FOR DEBUGGING PURPOSES ONLY, IT WORKS ONLY IN DEBUG MODE
  ///
  /// deletes all tables and recreates them
  /// USE WITH CAUTION - this will delete all data in the database
  Future<void> reCreateDB() async {
    if (kDebugMode /* or some other flag */ ) {
      final m = createMigrator(); // changed to this
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);
      }
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Make sure that foreign keys are enabled
        await customStatement('PRAGMA foreign_keys = ON');
        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          await batch((b) {
            b.insert(categories, CategoriesCompanion.insert(name: "Category1"));
          });
        }
      },

      onCreate: (m) {
        return m.createAll();
      },
      onUpgrade: (m, from, to) {
        return m.createAll();
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
