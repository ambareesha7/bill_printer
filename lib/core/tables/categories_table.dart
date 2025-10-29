import 'package:drift/drift.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(min: 2, max: 100).unique().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();
  // TextColumn get content => text().named('body')();
}
