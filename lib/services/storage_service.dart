import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

class StorageService {
  // Use 10.0.2.2 for Android Emulator, or your IP address for physical devices
  static const String baseUrl = 'http://10.0.2.2:3000';

  static double salary = 0;
  static List<Expense> expenses = [];

  static Future<void> fetchSalary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/salary'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        salary = double.tryParse(data['amount'].toString()) ?? 0.0;
      }
    } catch (e) {
      print("Error fetching salary: $e");
    }
  }

  static Future<void> setSalary(double value) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/salary'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': value}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        salary = value;
      }
    } catch (e) {
      print("Error setting salary: $e");
    }
  }

  static Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/expenses'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = json.decode(response.body);
        expenses = data.map((e) => Expense.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  static Future<void> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/expenses'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': expense.title,
          'amount': expense.amount,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await fetchExpenses(); // Refresh list from DB
      }
    } catch (e) {
      print("Error adding expense: $e");
    }
  }

  static Future<void> deleteExpense(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/expenses/$id'));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        expenses.removeWhere((e) => e.id == id);
      }
    } catch (e) {
      print("Error deleting expense: $e");
    }
  }

  static double getBalance() {
    double total = expenses.fold(0.0, (sum, item) => sum + item.amount);
    return salary - total;
  }

  static double totalExpense() {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}