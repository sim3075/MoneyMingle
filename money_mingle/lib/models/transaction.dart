import 'dart:convert';

enum TransactionType { expense, income }

class Transaction {
  final TransactionType type;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? note;
  final String? receiptPath;
  final bool isFixed;

  Transaction({
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.note,
    this.receiptPath,
    this.isFixed = false,
  });

  Map<String, dynamic> toJson() => {
        'type': type == TransactionType.expense ? 'expense' : 'income',
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
        'note': note,
        'receiptPath': receiptPath,
        'isFixed': isFixed,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] == 'expense'
          ? TransactionType.expense
          : TransactionType.income,
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      note: json['note'],
      receiptPath: json['receiptPath'],
      isFixed: json['isFixed'] as bool? ?? false, 
    );
  }

  static List<Transaction> listFromJson(String jsonStr) {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((e) => Transaction.fromJson(e)).toList();
  }

  static String listToJson(List<Transaction> txs) =>
      jsonEncode(txs.map((e) => e.toJson()).toList());
}