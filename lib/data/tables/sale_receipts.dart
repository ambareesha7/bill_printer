import 'package:drift/drift.dart';

class SaleReceipts extends Table {
  TextColumn get id => text()();
  TextColumn get customerName => text().nullable()();
  TextColumn get preparedBy => text().nullable()();
  TextColumn get billItems => text()();
  IntColumn get totalAmount => integer()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
