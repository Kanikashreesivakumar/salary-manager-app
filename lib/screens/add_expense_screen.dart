import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/storage_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String selectedCategory = 'Shopping';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.orange},
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.red},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.purple},
    {'name': 'Other', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  Future<void> saveExpense() async {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text);

    if (title.isNotEmpty && amount != null) {
      await StorageService.addExpense(
        Expense(title: "$selectedCategory: $title", amount: amount),
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New Expense", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat['name'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat['name']),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? cat['color'] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'], color: isSelected ? Colors.white : Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            cat['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            _buildInputLabel("Expense Name"),
            _buildTextField(
              controller: titleController,
              hint: "e.g. Nike Shoes",
              icon: Icons.edit,
            ),
            const SizedBox(height: 25),
            _buildInputLabel("Amount"),
            _buildTextField(
              controller: amountController,
              hint: "0.00",
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text(
                  "Create Expense",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }
}