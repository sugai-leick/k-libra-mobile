import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';

class FinancialTransactionModel extends FinancialTransaction {
  const FinancialTransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.category,
    required super.description,
    required super.date,
  });

  factory FinancialTransactionModel.fromJson(Map<String, dynamic> json) {
    return FinancialTransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}

class CashFlowModel extends CashFlow {
  const CashFlowModel({
    required super.revenue,
    required super.expenses,
    required super.balance,
    required super.byCategory,
  });

  factory CashFlowModel.fromJson(Map<String, dynamic> json) {
    return CashFlowModel(
      revenue: (json['revenue'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      byCategory: Map<String, double>.from(
        (json['by_category'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
    );
  }
}
