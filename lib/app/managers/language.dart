import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<SetLanguageEvent>((event, emit) {
      emit(LanguageChanged());
    });
  }
}

sealed class LanguageState {}

final class LanguageInitial extends LanguageState {}

final class LanguageChanged extends LanguageState {}

sealed class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SetLanguageEvent extends LanguageEvent {}
