import 'package:flutter/material.dart';

class BillView extends StatefulWidget {
  const BillView({super.key});

  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  List<BillItem> items = [];
  double total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildBillTable(),
            _buildTotalSection(),
            _buildActionButtons(),
            _buildCategories(),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text(
            'Item Wise Bill',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Report'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Quick Bill'),
          ),
        ],
      ),
    );
  }

  Widget _buildBillTable() {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('ITEM')),
                Expanded(child: Text('QTY')),
                Expanded(child: Text('RATE')),
                Expanded(child: Text('TOTAL')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildBillRow(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
  // Add this method after _buildBillTable()

  Widget _buildBillRow(BillItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(item.name)),
          Expanded(child: Text(item.quantity.toString())),
          Expanded(child: Text('₹${item.rate}')),
          Expanded(child: Text('₹${item.total}')),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${items.length}'),
          Text('₹${total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Add Product'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Print'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip('ALL', isSelected: true),
          _buildCategoryChip('Breakfast1'),
          _buildCategoryChip('Category 1'),
          _buildCategoryChip('Category 2'),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(8),
        childAspectRatio: 1.5,
        children: [
          _buildProductCard('Coffee', 20),
          _buildProductCard('Rice', 65),
          _buildProductCard('Rice bath', 30),
          _buildProductCard('Dosa', 40),
          _buildProductCard('Idli', 30),
          _buildProductCard('Product 1', 10),
          _buildProductCard('Product 2', 20),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.orange : Colors.grey[800],
      ),
    );
  }

  Widget _buildProductCard(String name, double price) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 16)),
            Text('₹$price', style: const TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}

class BillItem {
  final String name;
  final int quantity;
  final double rate;
  double get total => quantity * rate;

  BillItem({required this.name, required this.quantity, required this.rate});
}
