import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/checklists_repository.dart';
import '../../data/database.dart' as database;

const _bg = Color(0xFF0E1A0F);
const _card = Color(0xFF122414);
const _neon = Color(0xFF00FF33);

class ChecklistDetailView extends ConsumerStatefulWidget {
  final String checklistId;

  const ChecklistDetailView({super.key, required this.checklistId});

  @override
  ConsumerState<ChecklistDetailView> createState() =>
      _ChecklistDetailViewState();
}

class _ChecklistDetailViewState extends ConsumerState<ChecklistDetailView> {
  late TextEditingController _taskController;
  // late Checklist checkli st;
  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
    debugLog(widget.checklistId, tag: "ID");
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;

    final dao = ref.read(checklistDaoProvider);
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    await dao.createTask(
      id: taskId,
      checklistId: widget.checklistId,
      taskText: text,
    );
    _taskController.clear();
  }

  Future<void> _toggleTaskStatus(database.ChecklistTask task) async {
    final dao = ref.read(checklistDaoProvider);
    await dao.toggleTaskStatus(task.id);
  }

  Future<void> _deleteTask(database.ChecklistTask task) async {
    final dao = ref.read(checklistDaoProvider);
    await dao.deleteTask(task.id);
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.read(checklistDaoProvider);
    final tasksStream = dao.watchTasksFor(widget.checklistId);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Checklist'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<database.ChecklistTask>>(
          stream: tasksStream,
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? [];
            final completed = tasks.where((t) => t.done).length;
            final total = tasks.length;
            final percent = total == 0
                ? 0
                : ((completed / total) * 100).round();
            final pending = tasks.where((t) => !t.done).toList();
            final done = tasks.where((t) => t.done).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Overall Progress',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              color: _neon,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: total == 0 ? 0 : completed / total,
                          minHeight: 12,
                          color: _neon,
                          backgroundColor: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completed of $total tasks completed',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (pending.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'PENDING',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ...pending.map(
                          (t) => _taskTile(
                            t,
                            onToggle: () => _toggleTaskStatus(t),
                            onDelete: () => _deleteTask(t),
                          ),
                        ),
                      ],
                      if (done.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          child: Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ...done.map(
                          (t) => _taskTile(
                            t,
                            onToggle: () => _toggleTaskStatus(t),
                            onDelete: () => _deleteTask(t),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _taskController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Add a new task...',
                              hintStyle: TextStyle(color: Colors.greenAccent),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _addTask(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: _neon,
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: _addTask,
                          icon: const Icon(Icons.add),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: _card,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.list, color: _neon),
              Icon(Icons.calendar_today, color: Colors.greenAccent),
              Icon(Icons.folder, color: Colors.greenAccent),
              Icon(Icons.settings, color: Colors.greenAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskTile(
    database.ChecklistTask task, {
    required VoidCallback onToggle,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: task.done ? Colors.blue : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green[700]!),
              ),
              child: task.done
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.taskText,
              style: TextStyle(
                color: task.done ? Colors.grey[400] : Colors.white,
                decoration: task.done ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (!task.done)
            const Icon(Icons.drag_handle, color: Colors.greenAccent),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, color: Colors.red[300], size: 20),
          ),
        ],
      ),
    );
  }
}
