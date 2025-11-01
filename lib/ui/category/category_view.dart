import 'package:bill_printer/models/app_enums.dart';
import 'package:bill_printer/ui/category/category_provider.dart';
import 'package:bill_printer/ui/widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView>
    with SingleTickerProviderStateMixin {
  final TextEditingController cateEditingController = TextEditingController();
  TabController? _tabController;
  final int _tabCount = 2;
  String? errorText(int textLength, int minTextLength, int maxTextLength) {
    if (textLength > maxTextLength) {
      return "Name max length should be $maxTextLength";
    } else if (textLength < minTextLength) {
      return "Name minimum length should be $minTextLength";
    } else {
      return null;
    }
  }

  // create dialog
  addCategory({required OperationType operationType, int? id}) {
    int minTextLength = 2;
    int maxTextLength = 35;
    ref
        .read(textLengthProvider.notifier)
        .updateLength(cateEditingController.text.length);
    // calling this to update error text if any
    ref.watch(textLengthProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final tabIndex = ref.watch(tabIndexProvider);
        String itemType = tabIndex == 0 ? "Category" : "Product";
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${operationType.name} $itemType",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    return TextField(
                      decoration: InputDecoration(
                        hintText: "$itemType name",
                        errorText: errorText(
                          ref.watch(textLengthProvider),
                          minTextLength,
                          maxTextLength,
                        ),
                      ),
                      controller: cateEditingController,
                      onChanged: (value) {
                        ref
                            .read(textLengthProvider.notifier)
                            .updateLength(value.length);
                      },
                    );
                  },
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        cateEditingController.clear();
                        ref.read(textLengthProvider.notifier).updateLength(0);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (cateEditingController.text.isEmpty) return;
                        if (cateEditingController.text.length > maxTextLength) {
                          return;
                        }
                        if (cateEditingController.text.length < minTextLength) {
                          return;
                        }

                        if (tabIndex == 0) {
                          if (operationType == OperationType.add) {
                            ref
                                .read(categoryListProvider.notifier)
                                .addCategory(cateEditingController.text);
                          } else if (operationType == OperationType.edit &&
                              id != null) {
                            ref
                                .read(categoryListProvider.notifier)
                                .updateCategory(id, cateEditingController.text);
                          }
                        } else {
                          // ref
                          //     .read(tabIndexProvider.notifier)
                          //     .addCategory(cateEditingController.text);
                        }

                        cateEditingController.clear();

                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.green[500],
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    // add tab controller listener
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      ref.read(tabIndexProvider.notifier).updateTabIndex(_tabController!.index);
      // ref.watch(categoryListProvider);
      ref.read(categoryListProvider.notifier).getCategories();
    });
    ref.read(categoryListProvider.notifier).getCategories();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    cateEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabCount,
      initialIndex: ref.watch(tabIndexProvider),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Category/Products"),
          actions: [
            ElevatedButton(onPressed: () {}, child: Text("ItemWise Bill")),
          ],
          bottom: TabBar(
            controller: _tabController,
            onTap: (value) {
              debugPrint(value.toString());
            },
            tabs: [
              // using this Consumer widget to rebuild only the Tab when tabs are changed
              // otherwise riverpod will dispose the categoryListProvider when not in use
              Consumer(
                builder: (context, ref, child) {
                  ref.watch(categoryListProvider);
                  return Tab(text: "Categories");
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final tabIndex = ref.watch(tabIndexProvider);
                  return Tab(text: "Products $tabIndex");
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.import_export),
                label: Text("Export"),
              ),
              FloatingActionButton(
                onPressed: () {
                  addCategory(operationType: OperationType.add);
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final categories = ref.watch(categoryListProvider);
                if (categories.isEmpty) {
                  return Center(child: Text("No categories added yet."));
                }
                return GridView.builder(
                  itemCount: categories.length,
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GridCard(
                      text: category.name,
                      editFunc: () {
                        cateEditingController.text = categories[index].name;
                        addCategory(
                          operationType: OperationType.edit,
                          id: category.id,
                        );
                      },
                      deleteFunc: () {
                        ref
                            .read(categoryListProvider.notifier)
                            .deleteCategory(category.id!);
                      },
                    );
                  },
                );
              },
            ),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("All")),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("not implemented yet"),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: 3,
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      return GridCard(
                        text: "name",
                        price: index,
                        editFunc: () {},
                        deleteFunc: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
