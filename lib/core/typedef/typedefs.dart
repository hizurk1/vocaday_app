import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
