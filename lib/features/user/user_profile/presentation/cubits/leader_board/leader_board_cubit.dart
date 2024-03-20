import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/extensions/list.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_list_users.dart';

part 'leader_board_state.dart';

class LeaderBoardCubit extends Cubit<LeaderBoardState> {
  final GetListUsersUsecase getListUsersUsecase;

  LeaderBoardCubit(this.getListUsersUsecase) : super(LeaderBoardEmptyState());

  Future<void> getListUsers() async {
    emit(LeaderBoardLoadingState());

    final results = await getListUsersUsecase();

    results.fold(
      (failure) => emit(LeaderBoardErrorState(failure.message)),
      (list) {
        final points =
            List<UserEntity>.from(list).where((e) => e.point >= 0).toList()
              ..sort((a, b) => b.point.compareTo(a.point))
              ..take(10);

        final attendances = List<UserEntity>.from(list)
            .where((e) => e.attendance.isNotNullOrEmpty)
            .toList()
          ..sort((a, b) => b.attendance!.length.compareTo(a.attendance!.length))
          ..take(10);

        emit(LeaderBoardLoadedState(points: points, attendances: attendances));
      },
    );
  }
}
