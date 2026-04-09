import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/expense_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double salary = StorageService.salary;
    double totalExpense = StorageService.totalExpense();
    double balance = StorageService.getBalance();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Summary", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Income", "₹${salary.toStringAsFixed(0)}", Colors.greenAccent),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildSummaryItem("Spent", "₹${totalExpense.toStringAsFixed(0)}", Colors.orangeAccent),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildSummaryItem("Balance", "₹${balance.toStringAsFixed(0)}", Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: StorageService.expenses.isEmpty
                        ? const Center(child: Text("No transactions recorded"))
                        : ListView.builder(
                            itemCount: StorageService.expenses.length,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) {
                              final e = StorageService.expenses[index];
                              return ExpenseCard(expense: e);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}