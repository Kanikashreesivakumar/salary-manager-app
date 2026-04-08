import '../models/expense_model.dart';
class StorageService{
  static double salary =0;
  static List<Expense> expenses =[];

  static void setSalary(double value){
    salary = value;
  }

  static void addExpense(Expense expense){
    expenses.add(expense);

  }

  static double getBalance() {
    double totalExpense = expenses.fold(0, (sum, item) => sum + item.amount);
    return salary - totalExpense;
  }
  }
