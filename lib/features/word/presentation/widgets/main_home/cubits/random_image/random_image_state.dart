part of 'random_image_cubit.dart';

sealed class RandomImageState extends Equatable {
  const RandomImageState();

  @override
  List<Object> get props => [];
}

final class RandomImageEmptyState extends RandomImageState {}

final class RandomImageLoadingState extends RandomImageState {}

final class RandomImageLoadedState extends RandomImageState {
  final Uint8List imageBytes;

  const RandomImageLoadedState(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

final class RandomImageErrorState extends RandomImageState {
  final String message;

  const RandomImageErrorState(this.message);

  @override
  List<Object> get props => [message];
}
