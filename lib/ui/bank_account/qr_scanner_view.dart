import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedQrResult {
  const ScannedQrResult({required this.upiId, this.name});

  final String upiId;
  final String? name;
}

Future<ScannedQrResult?> showQrScanner(BuildContext context) {
  return showDialog<ScannedQrResult>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _QrScannerDialog(),
  );
}

class _QrScannerDialog extends StatefulWidget {
  const _QrScannerDialog();

  @override
  State<_QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<_QrScannerDialog> {
  final MobileScannerController controller = MobileScannerController();
  bool hasScanned = false;
  bool isInvalidQrPromptVisible = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleDetection(BarcodeCapture capture) {
    if (hasScanned) return;

    for (final barcode in capture.barcodes) {
      final String? rawValue = barcode.rawValue?.trim();
      if (rawValue == null || rawValue.isEmpty) continue;

      final Uri? uri = Uri.tryParse(rawValue);
      debugLog(rawValue, tag: "UPI");
      final bool isUpi = uri?.scheme.toLowerCase() == "upi";
      if (!isUpi) {
        showInvalidQrPrompt();
        return;
      }

      final String upiId = isUpi
          ? (uri?.queryParameters["pa"] ?? rawValue)
          : rawValue;
      final String? name = isUpi ? uri?.queryParameters["pn"] : null;

      hasScanned = true;
      Navigator.pop(context, ScannedQrResult(upiId: upiId, name: name));
      return;
    }
  }

  Future<void> showInvalidQrPrompt() async {
    if (isInvalidQrPromptVisible || !mounted) return;

    isInvalidQrPromptVisible = true;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid QR code"),
        content: const Text("Please show a proper UPI QR code."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    isInvalidQrPromptVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Scan UPI QR code"),
      contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      content: SizedBox(
        width: 320,
        height: 380,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MobileScanner(
                  controller: controller,
                  onDetect: handleDetection,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<MobileScannerState>(
                  valueListenable: controller,
                  builder: (context, state, child) => IconButton(
                    tooltip: state.cameraDirection == CameraFacing.front
                        ? "Use back camera"
                        : "Use front camera",
                    onPressed: controller.switchCamera,
                    icon: Icon(
                      state.cameraDirection == CameraFacing.front
                          ? Icons.camera_rear
                          : Icons.camera_front,
                    ),
                  ),
                ),
                ValueListenableBuilder<MobileScannerState>(
                  valueListenable: controller,
                  builder: (context, state, child) {
                    final IconData icon = switch (state.torchState) {
                      TorchState.on => Icons.flash_on,
                      TorchState.auto => Icons.flash_auto,
                      TorchState.unavailable => Icons.no_flash,
                      TorchState.off => Icons.flash_off,
                    };

                    return IconButton(
                      tooltip: "Toggle torch",
                      onPressed: state.torchState == TorchState.unavailable
                          ? null
                          : controller.toggleTorch,
                      icon: Icon(icon),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
