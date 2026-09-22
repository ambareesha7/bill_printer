import 'package:drift/drift.dart';

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get category => text().withLength(min: 1, max: 60)();
  IntColumn get amount => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get paymentReference => text().nullable().withLength(max: 120)();
  DateTimeColumn get spentAt => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
