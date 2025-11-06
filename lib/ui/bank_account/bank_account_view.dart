import 'package:bill_printer/data/app_enums.dart';
import 'package:bill_printer/data/models/bank_account/bank_account_model.dart';
import 'package:bill_printer/ui/bank_account/providers/bank_provider.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:bill_printer/ui/widgets/delete_btn.dart';
import 'package:bill_printer/ui/widgets/edit_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankAccountView extends StatelessWidget {
  const BankAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bank Accounts")),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add new account"),
        onPressed: () {
          openFormDialog(
            context: context,
            acc: BankAccountModel(name: ""),
            operationType: OperationType.add,
          );
        },
      ),
      body: Consumer(
        builder: (context, ref, child) {
          List<BankAccountModel> bankList = ref.watch(bankListProvider);
          return ListView.builder(
            itemCount: bankList.length,
            itemBuilder: (context, index) {
              BankAccountModel bankAccount = bankList[index];
              return Card(
                color: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText("Name: ${bankAccount.name}"),
                            if (bankAccount.accountNumber != null)
                              SelectableText(
                                "A/C no: ${bankAccount.accountNumber}",
                              ),
                            if (bankAccount.upiId != null)
                              SelectableText("UPI: ${bankAccount.upiId}"),
                            if (bankAccount.ifsc != null)
                              SelectableText("IFSC: ${bankAccount.ifsc}"),
                            if (bankAccount.note != null)
                              SelectableText("Note: ${bankAccount.note}"),
                            if (bankAccount.isPrime)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Prime Account ",
                                    style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            if (!bankAccount.isPrime)
                              InkWell(
                                onTap: () {
                                  if (bankAccount.isPrime) return;
                                  bankAccount = bankAccount.copyWith(
                                    isPrime: true,
                                  );
                                  ref
                                      .read(bankListProvider.notifier)
                                      .updatePrimeAccount(
                                        primeAccount: bankAccount,
                                      );
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 2,
                                      ),
                                      child: Text(
                                        "Set as prime",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                    Icon(Icons.circle_outlined),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          EditBtn(
                            onTap: () {
                              openFormDialog(
                                context: context,
                                acc: bankAccount,
                                operationType: OperationType.edit,
                              );
                            },
                          ),
                          DeleteBtn(
                            onTap: () {
                              UIUtils.confirmDialog(
                                context: context,
                                title: "Are you sure",
                                subTitle:
                                    "you want to delete ${bankAccount.name}",
                                rightFun: () {
                                  ref
                                      .read(bankListProvider.notifier)
                                      .deleteBankAccounts(bankAccount.id!);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static openFormDialog({
    required BuildContext context,
    required BankAccountModel acc,
    required OperationType operationType,
  }) {
    final TextEditingController nameEditController = TextEditingController();
    final TextEditingController accountEditController = TextEditingController();
    final TextEditingController ifscEditController = TextEditingController();
    final TextEditingController upiEditController = TextEditingController();
    final TextEditingController noteEditController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (operationType == OperationType.edit) {
      if (acc.accountNumber != null) {
        accountEditController.text = acc.accountNumber.toString();
      }
      nameEditController.text = acc.name;
      upiEditController.text = acc.upiId != null ? acc.upiId! : "";
      ifscEditController.text = acc.ifsc != null ? acc.ifsc! : "";
      noteEditController.text = acc.note != null ? acc.note! : "";
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${operationType.name} Bank Account",
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("*", style: TextStyle(color: Colors.red)),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Name",

                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          controller: nameEditController,
                        ),
                        SizedBox(height: 8),
                        Text("*", style: TextStyle(color: Colors.red)),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            } else if (!value.contains("@")) {
                              return "UPI ID should have @ symbol";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "UPI ID",
                            border: OutlineInputBorder(),
                          ),
                          controller: upiEditController,
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Account number",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: accountEditController,
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "IFSC",
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          controller: ifscEditController,
                        ),
                        SizedBox(height: 8),

                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Note",
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          controller: noteEditController,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (formKey.currentState!.validate()) {
                                  acc = acc.copyWith(
                                    name: nameEditController.text,
                                    upiId: upiEditController.text,
                                    accountNumber:
                                        accountEditController.text.isNotEmpty
                                        ? int.parse(accountEditController.text)
                                        : null,
                                    ifsc: ifscEditController.text.isNotEmpty
                                        ? ifscEditController.text
                                        : null,
                                    note: noteEditController.text.isNotEmpty
                                        ? noteEditController.text
                                        : null,
                                  );
                                  if (operationType == OperationType.add) {
                                    ref
                                        .read(bankListProvider.notifier)
                                        .addBankAccount(account: acc);
                                  } else {
                                    ref
                                        .read(bankListProvider.notifier)
                                        .updateBankAccount(account: acc);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              child: Text(
                                operationType == OperationType.add
                                    ? "Save"
                                    : "Update",
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
            ),
          ),
        );
      },
    );
  }
}
