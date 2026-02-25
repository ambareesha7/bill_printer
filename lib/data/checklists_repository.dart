import 'package:bill_printer/data/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

final checklistDaoProvider = Provider<ChecklistDao>((ref) {
  final db = ref.read(databaseProvider);
  return ChecklistDao(db);
});

class ChecklistDao {
  final AppDatabase _db;

  ChecklistDao(this._db);

  Stream<List<Checklist>> watchAll() {
    return (_db.select(_db.checklists)).watch();
  }

  Future<void> createChecklist({
    required String id,
    required String title,
    int total = 0,
    int completed = 0,
    int colorValue = 0,
    String? iconName,
  }) async {
    final companion = ChecklistsCompanion.insert(
      id: id,
      title: title,
      completed: Value(completed),
      total: Value(total),
      colorValue: Value(colorValue),
      iconName: Value(iconName),
      isActive: const Value(true),
    );
    await _db.into(_db.checklists).insert(companion);
  }

  Future<void> deleteChecklist(String id) async {
    await (_db.delete(_db.checklists)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<ChecklistTask>> tasksFor(String checklistId) {
    return (_db.select(
      _db.checklistTasks,
    )..where((t) => t.checklistId.equals(checklistId))).get();
  }

  // Task CRUD Operations

  /// Create a new task
  Future<void> createTask({
    required String id,
    required String checklistId,
    required String taskText,
    bool done = false,
    int position = 0,
  }) async {
    final companion = ChecklistTasksCompanion.insert(
      id: id,
      checklistId: checklistId,
      taskText: taskText,
      done: Value(done),
      position: Value(position),
    );
    await _db.into(_db.checklistTasks).insert(companion);
  }

  /// Get a single task by ID
  Future<ChecklistTask?> getTask(String taskId) {
    return (_db.select(
      _db.checklistTasks,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
  }

  /// Watch a single task for real-time updates
  Stream<ChecklistTask?> watchTask(String taskId) {
    return (_db.select(
      _db.checklistTasks,
    )..where((t) => t.id.equals(taskId))).watchSingleOrNull();
  }

  /// Watch all tasks for a checklist
  Stream<List<ChecklistTask>> watchTasksFor(String checklistId) {
    return (_db.select(
      _db.checklistTasks,
    )..where((t) => t.checklistId.equals(checklistId))).watch();
  }

  /// Update task details
  Future<void> updateTask({
    required String taskId,
    String? taskText,
    bool? done,
    int? position,
  }) async {
    final task = await getTask(taskId);
    if (task == null) return;

    final companion = ChecklistTasksCompanion(
      id: Value(task.id),
      checklistId: Value(task.checklistId),
      taskText: taskText != null ? Value(taskText) : Value(task.taskText),
      done: done != null ? Value(done) : Value(task.done),
      position: position != null ? Value(position) : Value(task.position),
      updatedAt: Value(DateTime.now()),
    );
    await _db.update(_db.checklistTasks).replace(companion);
  }

  /// Toggle task done status
  Future<void> toggleTaskStatus(String taskId) async {
    final task = await getTask(taskId);
    if (task == null) return;

    final companion = ChecklistTasksCompanion(
      id: Value(task.id),
      checklistId: Value(task.checklistId),
      taskText: Value(task.taskText),
      done: Value(!task.done),
      position: Value(task.position),
      updatedAt: Value(DateTime.now()),
    );
    await _db.update(_db.checklistTasks).replace(companion);
  }

  /// Delete a single task
  Future<void> deleteTask(String taskId) async {
    await (_db.delete(
      _db.checklistTasks,
    )..where((t) => t.id.equals(taskId))).go();
  }

  /// Delete all tasks for a checklist
  Future<void> deleteAllTasksFor(String checklistId) async {
    await (_db.delete(
      _db.checklistTasks,
    )..where((t) => t.checklistId.equals(checklistId))).go();
  }
}
