// ignore_for_file: use_build_context_synchronously

import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "printer_provider.g.dart";

@riverpod
class BLStatus extends _$BLStatus {
  @override
  bool build() {
    status();
    return false;
  }

  status() async {
    final bool connectionStatus = await PrintBluetoothThermal.bluetoothEnabled;
    state = connectionStatus;
  }
}

@riverpod
class Printer extends _$Printer {
  @override
  bool build() {
    status();
    return false;
  }

  Future<bool> connect(String mac) async {
    final bool result = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    debugLog("state conected $result");
    state = result;
    return result;
  }

  Future<bool> disconnect() async {
    final bool result = await PrintBluetoothThermal.disconnect;
    state = result;
    debugLog("status disconnect $result");
    return result;
  }

  Future<bool> status() async {
    final bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    state = connectionStatus;
    return connectionStatus;
  }

  Future<void> printBill({
    required BuildContext context,
    String? orderNo,
    String? paymentMode,
    String? dateTime,
    required List<BillItemModel> itemsList,
    required String totalAmount,
    required String totalItems,
  }) async {
    bool printerStatus = await status();
    if (printerStatus) {
      bool result = false;
      List<int> ticket = await billContent(
        businessName: "MoonLight Cafe",
        // subHeader1: "PayMode: $paymentMode",
        // shopID: "CartID: BTM-1",
        dateTime: dateTime,
        invoiceTitle: "Order no:",
        orderNo: orderNo,
        itemsList: itemsList,
        totalAmount: totalAmount,
        totalItems: totalItems,
        footerText: "Thank you, Visit again.",
      );
      result = await PrintBluetoothThermal.writeBytes(ticket);
      if (!result) {
        debugLog("Print unsuccessful");
        showToast(
          "Unable to print",
          context: context,
          backgroundColor: AppColors.red,
        );
      }
    } else {
      disconnect();
      showToast(
        "Please check the PRINTER connection",
        context: context,
        backgroundColor: AppColors.red,
      );
    }
  }

  Future<List<int>> billContent({
    String? businessName,
    String? address,
    String? subHeader1,
    String? dateTime,
    String? invoiceTitle,
    String? orderNo,
    String? shopID,
    required List<BillItemModel> itemsList,
    required String totalItems,
    required String totalAmount,
    required String footerText,
  }) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();
    // Header text1
    if (businessName != null) {
      bytes += generator.text(
        businessName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
    }
    // Address
    if (address != null) {
      bytes += generator.text(address);
    }

    // sub header1
    if (subHeader1 != null) {
      bytes += generator.text("$subHeader1 ${shopID ?? ""}");
    }
    // Date time
    if (dateTime != null) {
      bytes += generator.text(dateTime);
    }
    // Invoice title
    if (invoiceTitle != null) {
      bytes += generator.text(
        "$invoiceTitle ${orderNo ?? ""}",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
    }
    // Items table header
    bytes += generator.hr();
    bytes += generator.row(tableHeader());
    bytes += generator.hr();
    // Items table
    for (BillItemModel i in itemsList) {
      bytes += generator.row(buildItemsList([i]));
    }
    // Total section
    bytes += generator.hr();

    bytes += generator.text(
      "Totals: Items=$totalItems, Amount=$totalAmount",
      styles: const PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
        bold: true,
        align: PosAlign.center,
      ),
    );
    bytes += generator.hr();
    // Footer text1
    // bytes += generator.text(
    //   footerText,
    //   styles: const PosStyles(
    //     height: PosTextSize.size1,
    //     width: PosTextSize.size1,
    //     bold: true,
    //     align: PosAlign.center,
    //   ),
    // );

    bytes += generator.feed(3);
    // Invoice title
    if (invoiceTitle != null) {
      bytes += generator.text(
        "$invoiceTitle ${orderNo ?? ""}",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
    }
    bytes += generator.feed(4);
    return bytes;
  }

  List<PosColumn> tableHeader() {
    return [
      PosColumn(
        text: "Item",
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text: "Qty",
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text: "Rate",
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text: "Total",
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    ];
  }

  List<PosColumn> buildItemsList(List<BillItemModel> list) {
    List<PosColumn> items = [];
    for (var i in list) {
      items.add(
        PosColumn(
          text: i.name,
          width: 6,
          styles: const PosStyles(align: PosAlign.left, underline: true),
        ),
      );
      items.add(
        PosColumn(
          text: i.quantity.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
      );
      items.add(
        PosColumn(
          text: i.rate.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
      );
      items.add(
        PosColumn(
          text: (i.quantity * i.rate).toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center, underline: true),
        ),
      );
    }
    return items;
  }
}
