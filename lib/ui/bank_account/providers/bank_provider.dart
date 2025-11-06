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
    updateState();
    return [];
  }

  Future<void> addBankAccount({required BankAccountModel account}) async {
    await dbUtils.insertBankAccount(
      name: account.name,
      upiId: account.upiId!,
      accountNo: account.accountNumber,
      ifsc: account.ifsc,
      note: account.note,
      isPrime: account.isPrime,
    );
    updateState();
  }

  Future<void> updateBankAccount({required BankAccountModel account}) async {
    await dbUtils.updateBankAccount(
      id: account.id!,
      name: account.name,
      upiId: account.upiId,
      accountNo: account.accountNumber,
      ifsc: account.ifsc,
      note: account.note,
      isPrime: account.isPrime,
    );
    updateState();
  }

  deleteBankAccounts(int id) async {
    await dbUtils.deleteBankAccounts(id);
    updateState();
  }

  Future updateState() async {
    state = await dbUtils.parseBankAccounts();
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
        isPrime: acc.isPrime,
        createdAt: acc.createdAt,
        updatedAt: acc.updatedAt,
      );
    } else {
      return null;
    }
  }

  updatePrimeAccount({required BankAccountModel primeAccount}) async {
    List<BankAccountModel> oldPrimeAccountsList = [...state];
    for (var i in oldPrimeAccountsList) {
      if (i.isPrime) {
        i = i.copyWith(isPrime: false);
        await updateBankAccount(account: i);
      }
    }
    await updateBankAccount(account: primeAccount);
    await updateState();
  }
}
