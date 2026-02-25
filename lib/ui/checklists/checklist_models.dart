import 'package:flutter/material.dart';

class Checklist {
  final String id;
  final String title;
  final int completed;
  final int total;
  final IconData icon;
  final Color color;
  final bool active;

  Checklist({
    required this.id,
    required this.title,
    required this.completed,
    required this.total,
    required this.icon,
    required this.color,
    this.active = true,
  });

  double get progress => total == 0 ? 0 : (completed / total).clamp(0.0, 1.0);
}

class ChecklistTask {
  final String id;
  final String text;
  final bool done;

  ChecklistTask({required this.id, required this.text, this.done = false});
}
