import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  const GridCard({
    super.key,
    required this.text,
    this.price,
    required this.editFunc,
    required this.deleteFunc,
  });
  final String text;
  final String? price;
  final void Function() editFunc;
  final void Function() deleteFunc;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, textAlign: TextAlign.center),
                if (price != null)
                  Text("Rs: $price", textAlign: TextAlign.center),
              ],
            ),
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: editFunc,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.edit_document),
                ),
              ),
              MaterialButton(
                onPressed: deleteFunc,
                color: Colors.red[700],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
