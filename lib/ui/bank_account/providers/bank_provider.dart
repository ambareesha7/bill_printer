import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/bank_account/bank_account_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bank_provider.g.dart';

@riverpod
class BankList extends _$BankList {
  final DBUtils dbUtils = DBUtils.instance;

  @override
  List<BankAccountModel> build() {
    getBankAccounts();
    return [];
  }

  Future<void> addBankAccount({required BankAccountModel account}) async {
    await dbUtils.insertBankAccount(
      name: account.name,
      upiId: account.upiId!,
      accountNo: account.accountNumber,
      ifsc: account.ifsc,
      note: account.note,
    );
    getBankAccounts();
  }

  Future<void> updateBankAccount({required BankAccountModel account}) async {
    await dbUtils.updateBankAccount(
      id: account.id!,
      name: account.name,
      upiId: account.upiId,
      accountNo: account.accountNumber,
      ifsc: account.ifsc,
      note: account.note,
    );
    getBankAccounts();
  }

  deleteBankAccounts(int id) async {
    await dbUtils.deleteBankAccounts(id);
    getBankAccounts();
  }

  Future getBankAccounts() async {
    List<BankAccount> accounts = await dbUtils.getBankAccounts();
    state = accounts
        .map(
          (b) => BankAccountModel(
            id: b.id,
            name: b.name,
            upiId: b.upiId,
            accountNumber: b.accountNumber,
            ifsc: b.ifsc,
            note: b.note,
            createdAt: b.createdAt,
            updatedAt: b.updatedAt,
          ),
        )
        .toList();
  }

  Future<BankAccountModel?> getBankAccountByUpiID(String upiId) async {
    List<BankAccount> accountsList = await dbUtils.getBankAccountByUpiID(upiId);
    if (accountsList.isNotEmpty) {
      BankAccount acc = accountsList.last;
      return BankAccountModel(
        id: acc.id,
        name: acc.name,
        upiId: acc.upiId,
        accountNumber: acc.accountNumber,
        ifsc: acc.ifsc,
        note: acc.note,
        createdAt: acc.createdAt,
        updatedAt: acc.updatedAt,
      );
    } else {
      return null;
    }
  }
}
