import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_list_users.dart';

part 'leader_board_state.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  final GetListUsersUsecase getListUsersUsecase;

  LeaderBoardCubit(this.getListUsersUsecase) : super(LeaderBoardEmptyState());

  Future<void> getListUsers() async {
    emit(LeaderBoardLoadingState());

    final pointResults = await getListUsersUsecase((FilterUserType.point, 10));

    pointResults.fold((failure) => emit(LeaderBoardErrorState(failure.message)),
        (points) async {
      final attResults =
          await getListUsersUsecase((FilterUserType.attendance, 10));

      attResults.fold(
        (failure) => emit(LeaderBoardErrorState(failure.message)),
        (atts) {
          emit(LeaderBoardLoadedState(points: points, attendances: atts));
        },
      );
    });
  }
}
