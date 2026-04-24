import 'package:equatable/equatable.dart';

class FinancialTransaction extends Equatable {
  final String id;
  final double amount;
  final String type; // 'INCOME' or 'EXPENSE'
  final String category;
  final String description;
  final DateTime date;

  const FinancialTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, type, category, description, date];
}

class CashFlow extends Equatable {
  final double revenue;
  final double expenses;
  final double balance;
  final Map<String, double> byCategory;

  const CashFlow({
    required this.revenue,
    required this.expenses,
    required this.balance,
    required this.byCategory,
  });

  @override
  List<Object?> get props => [revenue, expenses, balance, byCategory];
}
