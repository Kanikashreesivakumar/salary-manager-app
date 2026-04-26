import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/storage_service.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onRefresh;

  const ExpenseCard({super.key, required this.expense, required this.onRefresh});

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Transaction"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount (₹)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () async {
              final newTitle = titleController.text;
              final newAmount = double.tryParse(amountController.text);
              if (newTitle.isNotEmpty && newAmount != null && expense.id != null) {
                await StorageService.updateExpense(expense.id!, newTitle, newAmount);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onRefresh(); // Refresh Dashboard
                }
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.red),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "ID: #${expense.id}",
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "- ₹${expense.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            // EDIT BUTTON
            IconButton(
              icon: Icon(Icons.edit_note, color: Colors.blue[400], size: 28),
              onPressed: () => _showEditDialog(context),
            ),
            // DELETE BUTTON
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete?"),
                    content: const Text("Delete this transaction?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                      TextButton(
                        onPressed: () async {
                          if (expense.id != null) {
                            await StorageService.deleteExpense(expense.id!);
                            if (context.mounted) {
                              Navigator.pop(ctx);
                              onRefresh();
                            }
                          }
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}