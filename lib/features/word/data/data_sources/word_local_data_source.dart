import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/utils/json_loader.dart';
import '../models/word_model.dart';

abstract interface class WordLocalDataSource {
  Future<List<WordModel>> getAllWords();
}

class WordLocalDataSourceImpl implements WordLocalDataSource {
  @override
  Future<List<WordModel>> getAllWords() async {
    try {
      final result = await JsonLoader.load(Assets.data.selected);
      return WordModel.fromRawJsonToListModel(result);
    } on UnimplementedError {
      rethrow;
    }
  }
}
