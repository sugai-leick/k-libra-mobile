import 'package:flutter_app/features/fiscal/domain/entities/invoice_entities.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.number,
    required super.series,
    required super.accessKey,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.xmlUrl,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      number: json['number'] as String,
      series: json['series'] as String,
      accessKey: json['access_key'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      xmlUrl: json['xml_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'series': series,
      'access_key': accessKey,
      'amount': amount,
      'status': status,
    };
  }
}
