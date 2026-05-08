import 'package:bill_printer/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/checklists_repository.dart';
import 'checklist_models.dart';
import 'new_checklist_modal.dart';

const _bg = Color(0xFF0E1A0F);
const _card = Color(0xFF122414);
const _neon = Color(0xFF00FF33);

class ChecklistListView extends ConsumerStatefulWidget {
  const ChecklistListView({super.key});

  @override
  ConsumerState<ChecklistListView> createState() => _ChecklistListViewState();
}

class _ChecklistListViewState extends ConsumerState<ChecklistListView> {
  final _items = <Checklist>[
    Checklist(
      id: '1',
      title: 'Grocery List',
      completed: 7,
      total: 10,
      icon: Icons.shopping_cart,
      color: _neon,
    ),
    Checklist(
      id: '2',
      title: 'Project Launch',
      completed: 12,
      total: 15,
      icon: Icons.rocket_launch,
      color: Colors.greenAccent,
    ),
    Checklist(
      id: '3',
      title: 'Packing List: Tokyo',
      completed: 4,
      total: 20,
      icon: Icons.local_airport,
      color: Colors.lightGreenAccent,
    ),
    Checklist(
      id: '4',
      title: 'Morning Routine',
      completed: 5,
      total: 5,
      icon: Icons.check_circle,
      color: Colors.greenAccent,
      active: false,
    ),
    Checklist(
      id: '5',
      title: 'Home Renovation',
      completed: 0,
      total: 5,
      icon: Icons.home,
      color: Colors.green,
    ),
  ];

  void _openNew() async {
    final res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewChecklistModal(),
    );
    if (res != null && res is Map) {
      final title = (res['title'] as String?) ?? 'Untitled';
      final color = (res['color'] as Color?)?.toARGB32() ?? 0;
      final iconName = (res['icon'] as IconData?)?.codePoint.toString();
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final dao = ref.read(checklistDaoProvider);
      await dao.createChecklist(
        id: id,
        title: title,
        total: 0,
        completed: 0,
        colorValue: color,
        iconName: iconName,
      );
      // TODO: refresh UI/watching queries - currently sample data remains
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Checklists'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // tabs row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTab('All', active: true),
                _buildTab('Personal'),
                _buildTab('Work'),
                _buildTab('Shared'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final it = _items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ChecklistCard(item: it),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _neon,
        foregroundColor: Colors.black,
        onPressed: _openNew,
        child: const Icon(Icons.add, size: 32),
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTab(String t, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        t,
        style: TextStyle(
          color: active ? _neon : Colors.green[200],
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  // Widget _buildBottomNav() {
  //   return BottomNavigationBar(
  //     backgroundColor: _card,
  //     selectedItemColor: _neon,
  //     unselectedItemColor: Colors.green[200],
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //       BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Checklists'),
  //       BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
  //       BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  //     ],
  //     currentIndex: 1,
  //     onTap: (_) {},
  //   );
  // }
}

class _ChecklistCard extends StatelessWidget {
  final Checklist item;

  const _ChecklistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final percent = (item.progress * 100).round();
    return Material(
      color: _card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push("/${RouterPaths.checklistDetails.name}/${item.id}");
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => Scaffold(body: Center(child: Text(item.title))),
          //   ),
          // );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.color),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.completed} of ${item.total} tasks completed',
                            style: TextStyle(color: Colors.green[200]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      if (item.active)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: _neon,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: item.progress,
                  minHeight: 8,
                  color: _neon,
                  backgroundColor: Colors.green[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
