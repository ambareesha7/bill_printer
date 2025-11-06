import 'package:drift/drift.dart';

class BankAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get accountNumber => integer().nullable()();
  TextColumn get ifsc => text().nullable()();
  TextColumn get upiId => text().unique()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
