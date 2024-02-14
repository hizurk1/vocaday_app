import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { online, offline }

class ConnectionCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription _streamSubscription;

  ConnectionCubit(this.connectivity) : super(const InternetState.online());

  initialize() async {
    final result = await Connectivity().checkConnectivity();
    _checkConnection(result);
    _streamSubscription =
        connectivity.onConnectivityChanged.listen(_checkConnection);
  }

  _checkConnection(ConnectivityResult result) {
    if (result != ConnectivityResult.wifi &&
        result != ConnectivityResult.mobile &&
        result != ConnectivityResult.ethernet &&
        result != ConnectivityResult.vpn) {
      emit(const InternetState.offline());
    } else {
      emit(const InternetState.online());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}

//* State
class InternetState extends Equatable {
  final ConnectionStatus status;
  const InternetState(this.status);

  const InternetState.online() : this(ConnectionStatus.online);

  const InternetState.offline() : this(ConnectionStatus.offline);

  @override
  List<Object?> get props => [status];
}
