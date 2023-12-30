import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionStatus { online, offline }

class ConnectionBloc extends Bloc<ConnectionEvent, InternetState> {
  final Connectivity connectivity;
  late StreamSubscription _streamSubscription;

  ConnectionBloc(this.connectivity) : super(const InternetState.online()) {
    _streamSubscription = connectivity.onConnectivityChanged.listen(
      (result) {
        if (result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile &&
            result != ConnectivityResult.ethernet &&
            result != ConnectivityResult.vpn) {
          add(NotConnectedEvent());
        } else {
          add(ConnectedEvent());
        }
      },
    );

    on<ConnectionEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(const InternetState.online());
      }
      if (event is NotConnectedEvent) {
        emit(const InternetState.offline());
      }
    });
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

//* Event
sealed class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

final class ConnectedEvent extends ConnectionEvent {}

final class NotConnectedEvent extends ConnectionEvent {}
