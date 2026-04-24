import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String id;
  final String number;
  final String series;
  final String accessKey;
  final double amount;
  final String status; // 'EMITTED', 'CANCELLED', 'ERROR'
  final DateTime createdAt;
  final String? xmlUrl;

  const InvoiceEntity({
    required this.id,
    required this.number,
    required this.series,
    required this.accessKey,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.xmlUrl,
  });

  @override
  List<Object?> get props => [id, number, series, accessKey, amount, status, createdAt, xmlUrl];
}
