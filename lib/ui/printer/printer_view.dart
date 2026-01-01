// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:bill_printer/ui/printer/providers/printer_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/printer_connection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterView extends ConsumerStatefulWidget {
  const PrinterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrinterViewState();
}

class _PrinterViewState extends ConsumerState<PrinterView> {
  String _info = "";
  String _msj = '';
  List<BluetoothInfo> items = [];

  bool _progress = false;
  String _msjprogress = "";

  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];
  // BluetoothInfo? connectedDevice;
  PrinterConnection printerConnection = PrinterConnection().instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    bool blEnabled = ref.watch(bLStatusProvider);
    bool connected = ref.watch(printerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printer Settings"),
        actions: [
          Icon(
            blEnabled ? Icons.bluetooth : Icons.bluetooth_disabled,
            color: AppColors.blue,
          ),
          IconButton(
            onPressed: () {
              reFreshStatus();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            Text('info: $_info'),
            if (!blEnabled)
              Text(
                "Bluetooth is off, please turn on the Bluetooth",
                style: TextStyle(color: AppColors.yellow),
                overflow: TextOverflow.ellipsis,
              ),
            Wrap(
              children: [
                Text("Printer: "),
                if (connected)
                  Icon(Icons.bluetooth_connected, color: AppColors.orange),
                if (connected && printerConnection.device != null)
                  Text(
                    "Name: ${printerConnection.device?.name}, Address: ${printerConnection.device?.macAdress}",
                    style: TextStyle(color: AppColors.blue),
                    overflow: TextOverflow.ellipsis,
                  ),
                if (!connected)
                  Text(
                    "Printer is not connected",
                    style: TextStyle(color: AppColors.yellow),
                  ),
              ],
            ),
            Text(_msj),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Type print"),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: optionprinttype,
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      optionprinttype = newValue!;
                    });
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 5,
                children: [
                  ElevatedButton(
                    onPressed: blEnabled ? () => getBluetooths() : null,
                    child: Row(
                      children: [
                        Visibility(
                          visible: _progress,
                          child: const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 1,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(_progress ? _msjprogress : "Search"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: connected
                        ? () async {
                            bool result = await ref
                                .read(printerProvider.notifier)
                                .disconnect();
                            if (result) {
                              printerConnection.updateDevice(null);
                              showToast(
                                "Printer disconnected",
                                context: context,
                              );
                              setState(() {});
                            }
                            reFreshStatus();
                          }
                        : null,
                    child: const Text("Disconnect"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                // height: 300,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.withAlpha(50),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          ),
                        );
                        String mac = items[index].macAdress;
                        bool conn = await ref
                            .read(printerProvider.notifier)
                            .connect(mac);
                        if (conn) {
                          printerConnection.updateDevice(items[index]);
                          setState(() {});
                          showToast("Printer connected", context: context);
                        }
                        Navigator.of(context).pop();
                        reFreshStatus();
                      },
                      title: Text('Name: ${items[index].name}'),
                      subtitle: Text("macAddress: ${items[index].macAdress}"),
                      shape: BeveledRectangleBorder(side: BorderSide()),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int batteryLevel = 0;

    try {
      PermissionStatus status = await Permission.bluetooth.status;
      if (status.isDenied) {
        Permission.bluetooth.request();
      }
      ref.read(bLStatusProvider.notifier).status();
      ref.read(printerProvider.notifier).status();
      platformVersion = await PrintBluetoothThermal.platformVersion;
      batteryLevel = await PrintBluetoothThermal.batteryLevel;
      getBluetooths();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _info = "$platformVersion (battery: $batteryLevel%)";
    });
  }

  reFreshStatus() {
    ref.read(bLStatusProvider.notifier).status();
    ref.read(printerProvider.notifier).status();
    if (ref.watch(bLStatusProvider) || ref.watch(printerProvider)) {
      printerConnection.updateDevice(null);
    }
  }

  Future<void> getBluetooths() async {
    if (!ref.watch(bLStatusProvider)) return;
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
      items = [];
    });

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    setState(() {
      _progress = false;
    });

    if (listResult.isEmpty) {
      _msj =
          "There are no bluetooths linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }
}
