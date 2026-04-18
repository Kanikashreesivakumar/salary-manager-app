import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/storage_service.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double totalSalary = StorageService.salary;
    double totalExpenses = StorageService.totalExpense();
    double balance = StorageService.getBalance();

    // Avoid division by zero
    double expensePercent = totalSalary > 0 ? (totalExpenses / totalSalary) * 100 : 0;
    double balancePercent = totalSalary > 0 ? (balance / totalSalary) * 100 : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Financial Summary", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expense Breakdown",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // PIE CHART
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value: totalExpenses,
                      title: '${expensePercent.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.greenAccent,
                      value: balance > 0 ? balance : 0,
                      title: '${balancePercent.toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // LEGEND CARDS
            _buildSummaryTile(
              "Total Income",
              "₹${totalSalary.toStringAsFixed(2)}",
              Colors.green,
              Icons.arrow_upward,
            ),
            const SizedBox(height: 15),
            _buildSummaryTile(
              "Total Expenses",
              "₹${totalExpenses.toStringAsFixed(2)}",
              Colors.red,
              Icons.arrow_downward,
            ),
            const SizedBox(height: 15),
            _buildSummaryTile(
              "Net Savings",
              "₹${balance.toStringAsFixed(2)}",
              Colors.blue,
              Icons.savings,
            ),
            
            const SizedBox(height: 40),
            
            // SUGGESTION BOX
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.orange, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      expensePercent > 70 
                        ? "Warning: Your expenses are over 70% of your income. Try to cut down on non-essentials."
                        : "Great job! Your savings are on track. Keep it up!",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}