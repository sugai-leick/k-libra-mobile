import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';

typedef ReturnStream<T> = Stream<Either<Failure, T>>;
