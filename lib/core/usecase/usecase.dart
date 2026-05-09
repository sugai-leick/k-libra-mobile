import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/typedefs/return_stream.dart';

abstract class Usecase<Params, ReturnType> {
  /// Executa a lógica de negócio do caso de uso.
  //Future<Either<Failure, ReturnType>> call(Params params);
  ReturnFuture<ReturnType> call(Params params);
}

/// Contrato para Casos de Uso (Usecases) que retornam um Stream (Reativo).
///
/// Ideal para escutar mudanças em tempo real do banco de dados (ex: Supabase Realtime).
///
/// [Params] - O objeto que contém os parâmetros necessários.
/// [ReturnType] - O tipo de dado emitido pelo stream.
abstract class StreamUsecase<Params, ReturnType> {
  /// Retorna um stream de dados reativos.
  ReturnStream<ReturnType> call(Params params);
}
