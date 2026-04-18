import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/storage_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  int chartType = 0; // 0: Bar (Overview), 1: Bar (Categories), 2: Pie

  Map<String, double> getCategoryData() {
    Map<String, double> categories = {
      'Shopping': 0,
      'Food': 0,
      'Transport': 0,
      'Bills': 0,
      'Other': 0,
    };

    for (var expense in StorageService.expenses) {
      String cat = 'Other';
      if (expense.title.contains(':')) {
        cat = expense.title.split(':').first.trim();
      }
      if (categories.containsKey(cat)) {
        categories[cat] = (categories[cat] ?? 0) + expense.amount;
      } else {
        categories['Other'] = (categories['Other'] ?? 0) + expense.amount;
      }
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    double totalSalary = StorageService.salary;
    double totalExpenses = StorageService.totalExpense();
    double balance = StorageService.getBalance();

    double expensePercent = totalSalary > 0 ? (totalExpenses / totalSalary) * 100 : 0;
    double balancePercent = totalSalary > 0 ? (balance / totalSalary) * 100 : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Analytics", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CHART SELECTOR
            Container(
              margin: const EdgeInsets.bottom(20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildTabItem(0, "Overview"),
                  _buildTabItem(1, "Categories"),
                  _buildTabItem(2, "Ratio"),
                ],
              ),
            ),

            // MAIN CHART CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chartType == 0 ? "Income vs Expense" : chartType == 1 ? "Category Spending" : "Savings Ratio",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 250,
                    child: _buildSelectedChart(totalSalary, totalExpenses, balance, expensePercent, balancePercent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // STATS GRID
            Row(
              children: [
                Expanded(child: _buildSmallStatCard("Income", "₹${totalSalary.toInt()}", Colors.green, Icons.arrow_upward)),
                const SizedBox(width: 15),
                Expanded(child: _buildSmallStatCard("Expense", "₹${totalExpenses.toInt()}", Colors.red, Icons.arrow_downward)),
              ],
            ),
            const SizedBox(height: 15),
            _buildLargeStatCard("Available Balance", "₹${balance.toStringAsFixed(2)}", Colors.indigo),
            
            const SizedBox(height: 30),
            
            // CATEGORY LIST (ONLY SHOW IF CATEGORY CHART SELECTED)
            if (chartType == 1) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Spending by Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              ...getCategoryData().entries.where((e) => e.value > 0).map((e) => _buildCategoryRow(e.key, e.value, totalExpenses)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    bool isSelected = chartType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => chartType = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.indigo : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedChart(double salary, double expense, double balance, double expPer, double balPer) {
    if (chartType == 0) return _buildBarChart(salary, expense);
    if (chartType == 1) return _buildCategoryBarChart();
    return _buildPieChart(expense, balance, expPer, balPer);
  }

  Widget _buildBarChart(double salary, double expense) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (salary > expense ? salary : expense) * 1.2,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(value == 0 ? 'Income' : 'Expense', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: salary, color: Colors.green, width: 45, borderRadius: BorderRadius.circular(12))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: expense, color: Colors.redAccent, width: 45, borderRadius: BorderRadius.circular(12))]),
        ],
      ),
    );
  }

  Widget _buildCategoryBarChart() {
    var data = getCategoryData();
    List<BarChartGroupData> groups = [];
    int i = 0;
    data.forEach((key, value) {
      if (value > 0) {
        groups.add(BarChartGroupData(x: i++, barRods: [
          BarChartRodData(toY: value, color: _getCatColor(key), width: 25, borderRadius: BorderRadius.circular(6))
        ]));
      }
    });

    if (groups.isEmpty) return const Center(child: Text("No category data"));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                var keys = data.entries.where((e) => e.value > 0).map((e) => e.key).toList();
                if (value.toInt() < keys.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(keys[value.toInt()].substring(0, 3), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: groups,
      ),
    );
  }

  Widget _buildPieChart(double expense, double balance, double expPer, double balPer) {
    return PieChart(
      PieChartData(
        sectionsSpace: 5,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(color: Colors.redAccent, value: expense, title: '${expPer.toInt()}%', radius: 65, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: Colors.green, value: balance > 0 ? balance : 0, title: '${balPer.toInt()}%', radius: 65, titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Color _getCatColor(String cat) {
    switch (cat) {
      case 'Shopping': return Colors.orange;
      case 'Food': return Colors.red;
      case 'Transport': return Colors.blue;
      case 'Bills': return Colors.purple;
      default: return Colors.grey;
    }
  }

  Widget _buildSmallStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 5), Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12))]),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLargeStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
          ]),
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.account_balance, color: color)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String name, double amount, double total) {
    double percent = amount / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text("₹${amount.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey[200],
            color: _getCatColor(name),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}