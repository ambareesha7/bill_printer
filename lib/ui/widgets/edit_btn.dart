import 'package:flutter/material.dart';

class EditBtn extends StatelessWidget {
  const EditBtn({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      icon: Icon(Icons.edit_square),
      highlightColor: Colors.blue,
      color: Colors.yellow,
      onPressed: onTap,
    );
  }
}
