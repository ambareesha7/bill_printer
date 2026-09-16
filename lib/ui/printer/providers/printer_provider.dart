// ignore_for_file: use_build_context_synchronously

import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/bill_item_model.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "printer_provider.g.dart";

final DBUtils dbUtils = DBUtils.instance;

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

  Future<PrintSetting?> getPrinterSettings() async {
    return await dbUtils.getPrintSettings();
  }

  Future<void> printBill({
    required BuildContext context,
    String? orderNo,
    String? paymentMode,
    String? paymentStatus,
    String? dateTime,
    required List<BillItemModel> itemsList,
    required String totalAmount,
    required String totalItems,
  }) async {
    bool printerStatus = await status();
    final pSettings =
        await getPrinterSettings() ??
        PrintSetting(
          id: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
    if (printerStatus) {
      bool result = false;
      List<int> ticket = await billContent(
        businessName: pSettings.businessName,
        address: pSettings.placeAddress,
        paymentStatus: paymentStatus,
        gst: pSettings.gstNo,
        subHeader1: pSettings.headerText1,
        subHeader2: pSettings.headerText2,
        dateTime: dateTime,
        invoiceTitle: pSettings.invoiceTitle,
        orderNo: "Order no: $orderNo",
        itemsList: itemsList,
        totalAmount: totalAmount,
        totalItems: totalItems,
        footerText1: pSettings.footerText1,
        footerText2: pSettings.footerText2,
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
    String? paymentStatus,
    String? subHeader1,
    String? subHeader2,
    String? dateTime,
    String? invoiceTitle,
    String? orderNo,
    String? gst,
    required List<BillItemModel> itemsList,
    required String totalItems,
    required String totalAmount,
    String? footerText1,
    String? footerText2,
  }) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();
    // Header text1
    if (businessName != null && businessName.isNotEmpty) {
      bytes += generator.text(businessName, styles: headerStyle1);
    }
    // Address
    if (address != null && address.isNotEmpty) {
      bytes += generator.text(address);
    }

    // GST
    if (gst != null && gst.isNotEmpty) {
      bytes += generator.text(gst);
    }
    // sub header1
    if (subHeader1 != null && subHeader1.isNotEmpty) {
      bytes += generator.text(subHeader1);
    }
    // sub header2
    if (subHeader2 != null && subHeader2.isNotEmpty) {
      bytes += generator.text(subHeader2);
    }
    // paymentStatus
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      bytes += generator.text(paymentStatus, styles: headerStyle1);
    }
    // Invoice title
    if (invoiceTitle != null) {
      bytes += generator.text(invoiceTitle, styles: headerStyle1);
    }
    // Date time
    if (dateTime != null) {
      bytes += generator.text(dateTime);
    }
    // Order no
    if (orderNo != null) {
      bytes += generator.text(orderNo);
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
    if (footerText1 != null && footerText1.isNotEmpty) {
      bytes += generator.text(footerText1);
    }

    // Footer text2
    if (footerText2 != null && footerText2.isNotEmpty) {
      bytes += generator.text(
        footerText2,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          // height: PosTextSize.size2,
          // width: PosTextSize.size2,
        ),
      );
    }

    bytes += generator.feed(3);

    // Costumer copy here
    // if (businessName != null) {
    //   bytes += generator.text(businessName, styles: headerStyle1);
    // }
    // if (invoiceTitle != null) {
    //   bytes += generator.text(
    //     "$invoiceTitle ${orderNo ?? ""}",
    //     styles: const PosStyles(
    //       align: PosAlign.center,
    //       bold: true,
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ),
    //   );
    // }
    // bytes += generator.text(
    //   "Please wait we will call your OrderNo, Once your item is ready",
    //   styles: PosStyles(bold: true, align: PosAlign.center),
    // );
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

PosStyles get headerStyle1 => PosStyles(
  align: PosAlign.center,
  bold: true,
  height: PosTextSize.size2,
  width: PosTextSize.size2,
);
