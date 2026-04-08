import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  double getTotalExpense() {
    return StorageService.expenses.fold(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    double salary = StorageService.salary;
    double totalExpense = getTotalExpense();
    double balance = salary - totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text("Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salary: ₹ $salary", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Total Expense: ₹ $totalExpense",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text(
              "Balance: ₹ $balance",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            const Text(
              "All Expenses",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: StorageService.expenses.length,
                itemBuilder: (context, index) {
                  final e = StorageService.expenses[index];
                  return ListTile(
                    title: Text(e.title),
                    trailing: Text("₹ ${e.amount}"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}