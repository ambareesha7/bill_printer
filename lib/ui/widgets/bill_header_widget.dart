import 'package:flutter/material.dart';

class BillHeaderWidget extends StatelessWidget {
  const BillHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Bill Printer',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'By Ashwa Technologies',
          style: TextStyle(fontFeatures: [FontFeature.subscripts()]),
        ),
      ],
    );
  }
}
