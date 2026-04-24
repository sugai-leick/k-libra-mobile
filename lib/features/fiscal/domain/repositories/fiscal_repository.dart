import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/fiscal/domain/entities/invoice_entities.dart';

abstract class IFiscalRepository {
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices();
  Future<Either<Failure, void>> createInvoice(InvoiceEntity invoice);
}
