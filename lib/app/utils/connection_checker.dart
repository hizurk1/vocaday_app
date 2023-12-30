import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../../core/typedef/typedefs.dart';
import '../constants/app_string.dart';

class ConnectionChecker {
  FutureEither<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth) {
      return const Right(true);
    } else {
      return const Left(ConnectionFailure(
        AppStringConst.internetFailureMessage,
      ));
    }
  }
}
