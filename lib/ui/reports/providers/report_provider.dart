import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/sale_receipts/sale_receipt_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'report_provider.g.dart';

@riverpod
class MonthlyReport extends _$MonthlyReport {
  final DBUtils dbUtils = DBUtils.instance;
  @override
  List<SaleReceiptModel> build() {
    getAllTransactions();
    return [];
  }

  getAllTransactions() async {
    final List<SaleReceiptModel> saleTrans = await dbUtils.parseSaleReceipts();
    state = [...saleTrans];
  }

  int getTotalAmount() {
    int total = 0;
    for (var i in state) {
      total += i.totalAmount ?? 0;
    }
    return total;
  }
}
