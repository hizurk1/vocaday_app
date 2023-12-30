import '../typedef/typedefs.dart';

abstract class Usecases<Type, Params> {
  FutureEither<Type> call(Params params);
}

abstract class UsecasesNoParam<Type> {
  FutureEither<Type> call();
}
