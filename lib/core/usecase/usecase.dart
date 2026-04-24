import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';

/// Contrato para Casos de Uso (Usecases) que retornam um Future.
///
/// Use esta classe para operações assíncronas que seguem o padrão [Either]
/// do dartz para tratamento de erros [Failure] no lado esquerdo e o
/// [ReturnType] no lado direito.
///
/// [Params] - O objeto que contém os parâmetros necessários para o caso de uso.
/// [ReturnType] - O tipo de dado retornado em caso de sucesso.
abstract class Usecase<Params, ReturnType> {
  /// Executa a lógica de negócio do caso de uso.
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// Contrato para Casos de Uso (Usecases) que retornam um Stream (Reativo).
///
/// Ideal para escutar mudanças em tempo real do banco de dados (ex: Supabase Realtime).
///
/// [Params] - O objeto que contém os parâmetros necessários.
/// [ReturnType] - O tipo de dado emitido pelo stream.
abstract class StreamUsecase<Params, ReturnType> {
  /// Retorna um stream de dados reativos.
  Stream<Either<Failure, ReturnType>> call(Params params);
}
