import 'package:drift/drift.dart';

class Shops extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 100).unique()();
  BoolColumn get isPrime => boolean().withDefault(const Constant(false))();
  TextColumn get shopId => text().unique()();
  TextColumn get address => text().nullable()();
  TextColumn get mapAddress => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
