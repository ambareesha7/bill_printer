import 'dart:convert';
import 'dart:io';

import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/product_model.dart';
import 'package:bill_printer/ui/utils/file_manager.dart';
import 'package:intl/intl.dart';

class ProductTransferService {
  ProductTransferService._internal();

  static final ProductTransferService instance =
      ProductTransferService._internal();

  final FileManager _fileManager = FileManager().instance;

  Future<File> exportProducts(List<ProductModel> products) async {
    final timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
    final content = jsonEncode({
      'export_date': DateTime.now().toIso8601String(),
      'total_products': products.length,
      'products': products.map((product) => product.toJson()).toList(),
    });

    return _fileManager.saveFileToTemp(
      fileName: 'products_$timestamp.json',
      content: content,
    );
  }

  Future<bool> importProducts(File file) async {
    try {
      final content = await _fileManager.readFile(file: file);
      final jsonData = jsonDecode(content);
      if (jsonData is! Map || jsonData['products'] is! List) return false;

      for (final item in jsonData['products']) {
        if (item is! Map) continue;
        final product = ProductModel.fromJson(Map<String, Object?>.from(item));
        if (product.name == null || product.price == null) continue;

        await DBUtils.instance.insertProduct(
          name: product.name!,
          price: product.price!,
          priority: product.priority ?? 1,
        );
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
