import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/print_settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_settings_provider.g.dart';

@riverpod
class PrintSettingsNotifier extends _$PrintSettingsNotifier {
  final DBUtils dbUtils = DBUtils.instance;

  @override
  PrintSettingsModel? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final settings = await dbUtils.getPrintSettings();
    state = settings == null ? null : dbUtils.printSettingsToModel(settings);
  }

  Future<void> save(PrintSettingsModel settings) async {
    if (state?.id == null) {
      await dbUtils.insertPrintSettings(settings: settings);
    } else {
      await dbUtils.updatePrintSettings(
        settings: settings.copyWith(id: state!.id),
      );
    }
    await _load();
  }

  Future<void> delete() async {
    await dbUtils.deletePrintSettings();
    state = null;
  }
}
