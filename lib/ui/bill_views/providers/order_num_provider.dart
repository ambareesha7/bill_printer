import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "order_num_provider.g.dart";

DBUtils dbUtils = DBUtils.instance;

@riverpod
class OrderNum extends _$OrderNum {
  @override
  String build() {
    updateOrderNo();
    return "1";
  }

  updateOrderNo() async {
    int orderNo = await getOrderNum();
    state = orderNo.toString();
  }

  /// the order number starts from 1 every day
  /// I kept orderNo type as string, in case in future if we want to
  /// we can change orderNo to something else
  Future<int> getOrderNum() async {
    SaleReceipt? lastsaleReceipt = await dbUtils.getLastBillFromDB();
    String now = getYearMonthDay(DateTime.now());

    if (lastsaleReceipt == null) {
      return 1;
    } else if (getYearMonthDay(lastsaleReceipt.createdAt) == now) {
      int lastOrder = int.tryParse(lastsaleReceipt.orederNo) ?? 0;
      return lastOrder + 1;
    } else {
      return 1;
    }
  }
}
