import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'category_provider.g.dart';

@riverpod
class CategoryList extends _$CategoryList {
  @override
  List<CategoryModel> build() {
    getCategories();
    return [];
  }

  final DBUtils dbUtils = DBUtils.instance;

  addCategory(String name) async {
    await dbUtils.insertCategory(name: name);
    getCategories();
  }

  Future<List<CategoryModel>> getCategories() async {
    final categories = await dbUtils.getCategories();
    List<CategoryModel> categoryModels = categories
        .map(
          (e) => CategoryModel(
            id: e.id,
            name: e.name,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
    updateCategories(categoryModels);
    return categoryModels;
  }

  void updateCategories(List<CategoryModel> categories) {
    state = [...categories];
  }

  Future<void> updateCategory(int id, String name) async {
    await dbUtils.updateCategory(id, name);
    getCategories();
  }

  Future<void> deleteCategory(int id) async {
    await dbUtils.deleteCategory(id);
    getCategories();
  }

  void clearCategories() {
    state = [];
  }
}

@riverpod
class TabIndex extends _$TabIndex {
  @override
  int build() {
    return 0;
  }

  // Add methods to mutate the state
  updateTabIndex(int index) {
    state = index;
  }
}

@riverpod
class TextLength extends _$TextLength {
  @override
  int build() {
    return 0;
  }

  // Add methods to mutate the state
  updateLength(int length) {
    state = length;
  }
}
