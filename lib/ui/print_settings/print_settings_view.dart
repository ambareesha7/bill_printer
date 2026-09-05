import 'package:bill_printer/data/models/print_settings_model.dart';
import 'package:bill_printer/ui/print_settings/providers/print_settings_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintSettingsView extends ConsumerStatefulWidget {
  const PrintSettingsView({super.key});

  @override
  ConsumerState<PrintSettingsView> createState() => _PrintSettingsViewState();
}

class _PrintSettingsViewState extends ConsumerState<PrintSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  static const _fields = [
    ('businessName', 'Business Name'),
    ('placeAddress', 'Place/Address'),
    ('headerText1', 'Header Text (Contact No, Etc...)'),
    ('headerText2', 'Header Text 2 (Email, FSSAI, Etc...)'),
    ('gstNo', 'GST No'),
    ('invoiceTitle', 'Invoice Title'),
    ('footerText1', 'Footer Text'),
    ('footerText2', 'Footer Text 2'),
  ];

  @override
  void initState() {
    super.initState();
    for (final field in _fields) {
      _controllers[field.$1] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(printSettingsProvider, (_, next) {
      if (next != null) _fill(next);
    });
    final settings = ref.watch(printSettingsProvider);
    if (settings != null) _fill(settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Settings'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(34, 0, 34, 28),
          children: [
            ..._fields.expand(
              (field) => [
                Text(
                  field.$2,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _controllers[field.$1],
                  // style: const TextStyle(fontSize: 21),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xff363636),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
            SizedBox(
              height: 58,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.btnColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                onPressed: _save,
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fill(PrintSettingsModel settings) {
    final values = {
      'businessName': settings.businessName ?? '',
      'placeAddress': settings.placeAddress ?? '',
      'headerText1': settings.headerText1 ?? '',
      'headerText2': settings.headerText2 ?? '',
      'gstNo': settings.gstNo ?? '',
      'invoiceTitle': settings.invoiceTitle ?? '',
      'footerText1': settings.footerText1 ?? '',
      'footerText2': settings.footerText2 ?? '',
    };
    for (final entry in values.entries) {
      if (_controllers[entry.key]!.text != entry.value) {
        _controllers[entry.key]!.text = entry.value;
      }
    }
  }

  Future<void> _save() async {
    String? valueFor(String key) {
      final value = _controllers[key]!.text.trim();
      return value.isEmpty ? null : value;
    }

    final settings = PrintSettingsModel(
      id: ref.read(printSettingsProvider)?.id,
      businessName: valueFor('businessName'),
      placeAddress: valueFor('placeAddress'),
      headerText1: valueFor('headerText1'),
      headerText2: valueFor('headerText2'),
      gstNo: valueFor('gstNo'),
      invoiceTitle: valueFor('invoiceTitle'),
      footerText1: valueFor('footerText1'),
      footerText2: valueFor('footerText2'),
    );
    await ref.read(printSettingsProvider.notifier).save(settings);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Print settings saved')));
    }
  }
}
