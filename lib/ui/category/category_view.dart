import 'package:bill_printer/core/database.dart';
import 'package:bill_printer/core/db_utils.dart';
import 'package:bill_printer/ui/widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  final DBUtils dbUtils = DBUtils.instance;
  final TextEditingController categoryController = TextEditingController();
  List<Category> categories = [];
  // create dialog
  // TODO: implement error handling for duplicate category names, name length
  // TODO: implement update category
  addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: TextField(
            decoration: InputDecoration(hintText: "Category Name"),
            controller: categoryController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                categoryController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  dbUtils.insertCategory(name: categoryController.text);
                  categoryController.clear();
                }
                // dbUtils.insertCategory(name: categoryController.text);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Category/Products"),
          actions: [
            ElevatedButton(onPressed: () {}, child: Text("ItemWise Bill")),
          ],
          bottom: TabBar(
            // isScrollable: true,
            onTap: (value) {
              debugPrint(value.toString());
            },
            tabs: [
              Tab(text: "Categories"),
              Tab(text: "Products"),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final categories1 = await dbUtils.getCategories();
                  print("categories................");
                  print(categories.toString());
                  categories = categories1;
                  setState(() {});
                },
                icon: Icon(Icons.import_export),
                label: Text("Export"),
              ),
              FloatingActionButton(
                onPressed: () {
                  addCategory();
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Categories Tab
            GridView.builder(
              itemCount: categories.length,
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return GridCard(
                  text: categories[index].name,
                  // price: index,
                  editFunc: () {
                    categoryController.text = categories[index].name;
                    addCategory();
                    // dbUtils.updateCategory(
                    //   categories[index].id,
                    //   "Updated ${categories[index].name}",
                    // );
                  },
                  deleteFunc: () {
                    dbUtils.deleteCategory(categories[index].id);
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
