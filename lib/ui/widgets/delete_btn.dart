import 'package:flutter/material.dart';

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onTap,
      icon: Icon(Icons.delete),
      highlightColor: Colors.blue,
      color: Colors.red,
    );
  }
}
