import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/failures/sales_failure.dart';
import 'package:flutter_app/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:flutter_app/features/sales/data/models/sale_model.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';
import 'package:flutter_app/features/sales/domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements ISalesRepository {
  final ISalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SaleEntity>>> getSales() async {
    try {
      final models = await remoteDataSource.getSales();
      return Right(models);
    } catch (e) {
      return Left(SalesFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createSale(SaleEntity entity) async {
    try {
      final model = SaleModel.fromEntity(entity);
      await remoteDataSource.createSale(model);
      return const Right(null);
    } catch (e) {
      return Left(SalesFailure(msg: e.toString()));
    }
  }

  @override
  // Stream<Either<Failure, int>> watchTotalSales() {
  //   print('escutando strem de sales');
  //   return remoteDataSource.getTotalSales().map(
  //     (count) => Right<Failure, int>(count),
  //   );
  // }
  Stream<Either<Failure, int>> watchTotalSales() async* {
    try {
      await for (final total in remoteDataSource.watchTotalSales()) {
        yield Right(total);
      }
    } on Exception {
      yield Left(
        SalesFailure(msg: 'Nao foi possivel recuperar os dados agora'),
      );
    }
  }
}
