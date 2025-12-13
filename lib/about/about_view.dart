import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:bill_printer/ui/widgets/bill_header_widget.dart';
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
  String _buildNumber = "-";

  final String _supportEmail = "ambareesha7@gmail.com";
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
        _buildNumber = info.buildNumber;
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
    final versionDisplay = '$_version (build $_buildNumber)';
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                BillHeaderWidget(),
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
              onTap: () => _copyToClipboard(_supportEmail, 'Email'),
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
              onTap: () => _copyToClipboard(_supportPhone, 'Phone number'),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () =>
                    _copyToClipboard(_supportPhone, 'Phone number'),
                tooltip: 'Copy phone number',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
