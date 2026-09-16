import 'package:bill_printer/data/tables/products_table.dart';
import 'package:bill_printer/data/tables/tags.dart';
import 'package:drift/drift.dart';

class ProductTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pruductId => integer().references(Products, #id)();
  IntColumn get tagId => integer().references(Tags, #id)();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
