import 'package:bill_printer/data/db_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "unit_id.g.dart";

DBUtils dbUtils = DBUtils.instance;

@riverpod
class UnitId extends _$UnitId {
  @override
  String build() {
    updateUnitId();
    return "ML1";
  }

  resetOrderNo() async {
    state = "ML1";
  }

  updateUnitId() async {
    // int orderNo = await getOrderNum();
    // state = orderNo.toString();
  }
}
