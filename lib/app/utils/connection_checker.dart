import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../../core/typedef/typedefs.dart';
import '../translations/translations.dart';

class ConnectionChecker {
  FutureEither<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth) {
      return const Right(true);
    } else {
      return Left(ConnectionFailure(
        LocaleKeys.utils_no_internet_connection.tr(),
      ));
    }
  }
}
