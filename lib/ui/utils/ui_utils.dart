import 'package:flutter/material.dart';

class UIUtils {
  static showSnackBar({
    required BuildContext context,
    required String text,
    Color? bgColor,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text), backgroundColor: bgColor));
  }

  static confirmDialog({
    required BuildContext context,
    required String title,
    String? subTitle,
    String? rightBtnName,
    String? leftBtnName,
    Function()? rightFun,
    Function()? leftFun,
    Color? rightBtnColor,
    Color? leftBtnColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // head row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                // Title text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title, style: TextStyle(fontSize: 18)),
                ),
                // subTitle text
                if (subTitle != null) Text(subTitle),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (leftFun != null) {
                          leftFun();
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: leftBtnColor ?? Colors.blueGrey,
                      ),
                      child: Text(
                        leftBtnName ?? "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (rightFun != null) {
                          rightFun();
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rightBtnColor ?? Colors.red,
                      ),
                      child: Text(
                        rightBtnName ?? "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
