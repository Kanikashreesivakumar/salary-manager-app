import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  final controller = TextEditingController();

  Future<void> saveSalary() async {
    final value = double.tryParse(controller.text);
    if (value != null) {
      await StorageService.setSalary(value);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Update Income", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet, size: 60, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              "What is your monthly income?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Setting your income helps you track your savings more accurately.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
              decoration: InputDecoration(
                hintText: "₹ 0.00",
                hintStyle: TextStyle(color: Colors.grey[300]),
                border: InputBorder.none,
                prefixText: "₹ ",
                prefixStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: saveSalary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text(
                  "Confirm Income",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Not now", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}