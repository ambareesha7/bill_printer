import 'package:flutter/material.dart';

const _bg = Color(0xFF0E1A0F);
const _card = Color(0xFF122414);
const _neon = Color(0xFF00FF33);

class NewChecklistModal extends StatefulWidget {
  const NewChecklistModal({super.key});

  @override
  State<NewChecklistModal> createState() => _NewChecklistModalState();
}

class _NewChecklistModalState extends State<NewChecklistModal> {
  Color _picked = _neon;
  IconData _icon = Icons.list;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scroller) {
        return Container(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(18),
          child: ListView(
            controller: scroller,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: _neon)),
                  ),
                  const Text(
                    'New Checklist',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Checklist Name',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. Vacation Packing',
                    hintStyle: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Theme Color', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Row(children: _colorChoices()),
              const SizedBox(height: 16),
              const Text('Icon', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Wrap(spacing: 12, runSpacing: 12, children: _iconChoices()),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _neon,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // return the new checklist data (minimal)
                  Navigator.of(context).pop({
                    'title': _controller.text,
                    'color': _picked,
                    'icon': _icon,
                  });
                },
                child: const Text(
                  'Create Checklist  →',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _colorChoices() {
    final colors = [
      _neon,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.blueGrey,
    ];
    return colors
        .map(
          (c) => GestureDetector(
            onTap: () => setState(() => _picked = c),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c,
                border: _picked == c
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _iconChoices() {
    final icons = [
      Icons.list,
      Icons.home,
      Icons.business_center,
      Icons.local_airport,
      Icons.restaurant,
      Icons.money,
      Icons.movie,
      Icons.more_horiz,
    ];
    return icons
        .map(
          (ic) => GestureDetector(
            onTap: () => setState(() => _icon = ic),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: _icon == ic ? Border.all(color: _neon, width: 3) : null,
              ),
              child: Icon(
                ic,
                color: _icon == ic ? _neon : Colors.greenAccent,
                size: 28,
              ),
            ),
          ),
        )
        .toList();
  }
}
