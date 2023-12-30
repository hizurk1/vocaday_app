import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class GetAllWordsUsecase extends UsecasesNoParam<List<WordEntity>> {
  final WordRepository repository;

  GetAllWordsUsecase({required this.repository});

  @override
  FutureEither<List<WordEntity>> call() async {
    return await repository.getAllWords();
  }
}
