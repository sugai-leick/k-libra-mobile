import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/fiscal/data/datasources/fiscal_remote_datasource.dart';
import 'package:flutter_app/features/fiscal/data/models/invoice_model.dart';
import 'package:flutter_app/features/fiscal/domain/entities/invoice_entities.dart';
import 'package:flutter_app/features/fiscal/domain/repositories/fiscal_repository.dart';

class FiscalRepositoryImpl implements IFiscalRepository {
  final IFiscalRemoteDataSource remoteDataSource;

  FiscalRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<InvoiceEntity>>> getInvoices() async {
    try {
      final invoices = await remoteDataSource.getInvoices();
      return Right(invoices);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> createInvoice(InvoiceEntity invoice) async {
    try {
      final model = InvoiceModel(
        id: invoice.id,
        number: invoice.number,
        series: invoice.series,
        accessKey: invoice.accessKey,
        amount: invoice.amount,
        status: invoice.status,
        createdAt: invoice.createdAt,
        xmlUrl: invoice.xmlUrl,
      );
      await remoteDataSource.createInvoice(model);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.msg});
}
