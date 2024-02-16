import 'dart:typed_data';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../app/managers/api.dart';
import '../../../../../../../injection_container.dart';

part 'random_image_state.dart';

class RandomImageCubit extends Cubit<RandomImageState> {
  RandomImageCubit() : super(RandomImageEmptyState());

  Future<void> getRandomImage(Size size) async {
    emit(RandomImageLoadingState());

    final result = await sl<CustomApiService>().getLoremPicsumImage(size);

    result.fold(
      (failure) => emit(RandomImageErrorState(failure.message)),
      (imgBytes) => emit(RandomImageLoadedState(imgBytes)),
    );
  }
}
