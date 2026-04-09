class Expense {
  final int? id;
  final String title;
  final double amount;

  Expense({this.id, required this.title, required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: double.parse(json['amount'].toString()),
    );
  }
}
