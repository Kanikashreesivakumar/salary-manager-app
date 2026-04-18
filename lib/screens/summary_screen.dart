import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/storage_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  int touchedIndex = -1;
  bool showBarChart = true;

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
        actions: [
          IconButton(
            icon: Icon(showBarChart ? Icons.pie_chart : Icons.bar_chart),
            onPressed: () => setState(() => showBarChart = !showBarChart),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CHART CARD
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
                        showBarChart ? "Income vs Expense" : "Spending Ratio",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: const Text("Monthly", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 250,
                    child: showBarChart 
                      ? _buildBarChart(totalSalary, totalExpenses)
                      : _buildPieChart(totalExpenses, balance, expensePercent, balancePercent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // STATS TILES
            Row(
              children: [
                Expanded(child: _buildSmallStatCard("Income", "₹${totalSalary.toInt()}", Colors.green)),
                const SizedBox(width: 15),
                Expanded(child: _buildSmallStatCard("Expense", "₹${totalExpenses.toInt()}", Colors.red)),
              ],
            ),
            const SizedBox(height: 15),
            _buildLargeStatCard("Available Balance", "₹${balance.toStringAsFixed(2)}", Colors.indigo),
            
            const SizedBox(height: 30),
            
            // INSIGHT CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF3949AB)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("AI Insight", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text(
                          expensePercent > 70 
                            ? "Your spending is high! Avoid 'Shopping' this week."
                            : "Financial health is good! You saved ${balancePercent.toInt()}% this month.",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(double salary, double expense) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: salary > expense ? salary * 1.2 : expense * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(value == 0 ? 'Income' : 'Expense', style: style),
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
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: salary, color: Colors.green, width: 40, borderRadius: BorderRadius.circular(8))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: expense, color: Colors.redAccent, width: 40, borderRadius: BorderRadius.circular(8))]),
        ],
      ),
    );
  }

  Widget _buildPieChart(double expense, double balance, double expPer, double balPer) {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 50,
        sections: [
          PieChartSectionData(
            color: Colors.redAccent,
            value: expense,
            title: '${expPer.toInt()}%',
            radius: 60,
            titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.green,
            value: balance > 0 ? balance : 0,
            title: '${balPer.toInt()}%',
            radius: 60,
            titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLargeStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 5),
              Text(value, style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.account_balance, color: color),
          )
        ],
      ),
    );
  }
}