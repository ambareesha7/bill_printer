import 'package:drift/drift.dart';

class PrintSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get businessName => text().nullable()();
  TextColumn get placeAddress => text().nullable()();
  TextColumn get headerText1 => text().nullable()();
  TextColumn get headerText2 => text().nullable()();
  TextColumn get gstNo => text().nullable()();
  TextColumn get invoiceTitle => text().nullable()();
  TextColumn get footerText1 => text().nullable()();
  TextColumn get footerText2 => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
