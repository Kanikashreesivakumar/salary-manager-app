import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  final controller = TextEditingController();

  void saveSalary() {
    final value = double.tryParse(controller.text);
    if (value != null) {
      StorageService.setSalary(value);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Salary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Salary"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveSalary,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}