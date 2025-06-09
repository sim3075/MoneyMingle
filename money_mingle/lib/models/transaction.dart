import 'dart:convert';

enum TransactionType { expense, income }

class Transaction {
  final String? id;
  final TransactionType type;
  final String title;
  final double amount;
  final DateTime date;
  final String? category;
  final String? note;
  final String? receiptPath;
  final bool isFixed;

  Transaction({
    this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    this.note,
    this.receiptPath,
    this.isFixed = false,
  });

  Map<String, dynamic> toMap() => {
        'type': type == TransactionType.expense ? 'expense' : 'income',
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category,
        'note': note,
        'receiptPath': receiptPath,
        'isFixed': isFixed,
      };

  factory Transaction.fromMap(Map<String, dynamic> map, String id) {
    return Transaction(
      id: id,
      type: map['type'] == 'expense'
          ? TransactionType.expense
          : TransactionType.income,
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category'],
      note: map['note'],
      receiptPath: map['receiptPath'],
      isFixed: map['isFixed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
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
      id: json['id'],
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

  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? title,
    double? amount,
    DateTime? date,
    String? category,
    String? note,
    String? receiptPath,
    bool? isFixed,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      isFixed: isFixed ?? this.isFixed,
    );
  }
}