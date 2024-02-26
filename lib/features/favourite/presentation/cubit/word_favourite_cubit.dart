import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'word_favourite_state.dart';

class WordFavouriteCubit extends Cubit<WordFavouriteState> {
  WordFavouriteCubit() : super(WordFavouriteInitial());
}
