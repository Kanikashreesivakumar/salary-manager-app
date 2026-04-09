import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';

class StorageService {
  // Use your computer's IP address if testing on a physical device. 
  // Use 10.0.2.2 for Android Emulator.
  static const String baseUrl = 'http://10.0.2.2:3000';

  static double salary = 0;
  static List<Expense> expenses = [];

  static Future<void> fetchSalary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/salary'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        salary = double.parse(data['amount'].toString());
      }
    } catch (e) {
      print("Error fetching salary: $e");
    }
  }

  static Future<void> setSalary(double value) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/salary'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': value}),
      );
      salary = value;
    } catch (e) {
      print("Error setting salary: $e");
    }
  }

  static Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/expenses'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        expenses = data.map((e) => Expense(
          title: e['title'],
          amount: double.parse(e['amount'].toString()),
        )).toList();
      }
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  static Future<void> addExpense(Expense expense) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/expenses'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': expense.title,
          'amount': expense.amount,
        }),
      );
      expenses.insert(0, expense); // Update local list
    } catch (e) {
      print("Error adding expense: $e");
    }
  }

  static double getBalance() {
    double total = expenses.fold(0, (sum, item) => sum + item.amount);
    return salary - total;
  }

  static double totalExpense() {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }
}
