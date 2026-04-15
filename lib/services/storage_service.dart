import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class StorageService {
  static const String baseUrl = 'http://localhost:3000';

  static double salary = 0;
  static List<Expense> expenses = [];
  static String? _token;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  static Future<bool> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  static Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<void> fetchSalary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/salary'), headers: _headers);
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
        headers: _headers,
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
      final response = await http.get(Uri.parse('$baseUrl/expenses'), headers: _headers);
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
        headers: _headers,
        body: json.encode({
          'title': expense.title,
          'amount': expense.amount,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await fetchExpenses();
      }
    } catch (e) {
      print("Error adding expense: $e");
    }
  }

  static Future<void> deleteExpense(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/expenses/$id'), headers: _headers);
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