// import 'package:drift/drift.dart';

// class ChecklistTasks extends Table {
//   TextColumn get id => text()();
//   TextColumn get checklistId =>
//       text().customConstraint('NOT NULL REFERENCES checklists(id)')();
//   TextColumn get taskText => text()();
//   BoolColumn get done => boolean().withDefault(const Constant(false))();
//   IntColumn get position => integer().withDefault(const Constant(0))();
//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
//   DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

//   @override
//   Set<Column> get primaryKey => {id};
// }
