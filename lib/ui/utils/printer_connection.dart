import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterConnection {
  PrinterConnection._private();
  static final PrinterConnection _instance = PrinterConnection._private();
  PrinterConnection get instance => _instance;

  factory PrinterConnection() {
    return _instance;
  }

  BluetoothInfo? _device;
  BluetoothInfo? get device => _device;
  updateDevice(BluetoothInfo? deviceInfo) {
    _device = deviceInfo;
  }
}
