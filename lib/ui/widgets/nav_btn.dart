import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBtn extends StatelessWidget {
  const NavBtn({super.key, required this.path, this.btnName});
  final String path;
  final String? btnName;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push("/$path");
      },
      child: Text(capitalize(btnName ?? path)),
    );
  }
}
