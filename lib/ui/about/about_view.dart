import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String _version = "-";

  final String _supportEmail = "ashwa22in@gmail.com";
  final String _supportPhone = "9141809886";

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = info.version;
      });
    } catch (e) {
      // keep defaults on error
      debugLog(e, tag: "Error while getting package info");
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
    } catch (e) {
      if (!mounted) return;
      debugLog(e, tag: "Error copying to clipboard");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to copy')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final versionDisplay = _version;
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Printer'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'Version: $versionDisplay',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Support Email'),
              subtitle: Text(_supportEmail),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(_supportEmail, 'Email'),
                tooltip: 'Copy email',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Support Phone'),
              subtitle: Text(_supportPhone),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () =>
                    _copyToClipboard(_supportPhone, 'Phone number'),
                tooltip: 'Copy phone number',
              ),
            ),
          ),
          const SizedBox(height: 38),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Bill Printer '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Transform.translate(
                      offset: const Offset(2, 4),
                      child: Text(
                        'By Ashwa Technologies',
                        textScaler: TextScaler.linear(0.7),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
