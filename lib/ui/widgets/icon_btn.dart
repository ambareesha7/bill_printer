import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({
    super.key,
    this.onTap,
    this.icon,
    this.iconColor,
    this.highlightColor,
    this.bgColor,
  });
  final void Function()? onTap;
  final IconData? icon;
  final Color? iconColor;
  final Color? highlightColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon ?? Icons.add),
      color: iconColor,
      highlightColor: highlightColor,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          bgColor ?? Colors.lightBlue,
        ),
      ),
    );
  }
}
