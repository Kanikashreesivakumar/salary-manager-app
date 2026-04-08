import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'add_expense_screen.dart';
import 'salary_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Balance", style: TextStyle(fontSize: 18)),
            Text(
              "₹ ${StorageService.getBalance()}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SalaryScreen()),
                    );
                    setState(() {});
                  },
                  child: const Text("Add Salary"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                    );
                    setState(() {});
                  },
                  child: const Text("Add Expense"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text("Expenses", style: TextStyle(fontSize: 18)),

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