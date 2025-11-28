import 'package:flutter/material.dart';

class BillHeaderWidget extends StatelessWidget {
  const BillHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Icon(Icons.receipt, size: 80, color: Colors.green)),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Bill Printer',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
