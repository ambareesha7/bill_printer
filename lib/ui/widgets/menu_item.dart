import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, this.child, this.name, this.subName, this.onTap});

  final Widget? child;
  final String? name;
  final String? subName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (child != null) child!,
              if (name != null)
                Flexible(
                  child: Text(
                    capitalize(name ?? ""),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
              if (subName != null)
                Text(subName ?? "", style: const TextStyle()),
            ],
          ),
        ),
      ),
    );
  }
}
