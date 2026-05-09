import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';

typedef ReturnFuture<T> = Future<Either<Failure, T>>;

