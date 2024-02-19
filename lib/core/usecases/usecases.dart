import '../typedef/typedefs.dart';

/// **Type:** return type of call function.
///
/// **Params:** parameters for call function.
abstract class Usecases<Type, Params> {
  FutureEither<Type> call(Params params);
}

/// **Type:** return type of call function.
abstract class UsecasesNoParam<Type> {
  FutureEither<Type> call();
}
