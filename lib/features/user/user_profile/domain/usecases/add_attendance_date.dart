import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class AddAttendanceDateUsecase
    extends Usecases<bool, (String, List<DateTime>)> {
  final UserRepository repository;

  AddAttendanceDateUsecase({required this.repository});

  @override
  FutureEither<bool> call((String, List<DateTime>) params) async {
    final String uid = params.$1;
    final List<DateTime> attendance = params.$2;

    return await repository.addAttendanceDate(
      uid: uid,
      attendance: attendance,
    );
  }
}
