import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../config/app_logger.dart';
import '../../core/errors/failure.dart';
import '../../core/typedef/typedefs.dart';

class CustomApiService {
  final Dio _dio;

  CustomApiService(this._dio);

  FutureEither<Uint8List> getLoremPicsumImage(Size size) async {
    try {
      final response = await _dio.get(
        "https://picsum.photos/${size.width.toInt()}/${size.height.toInt()}",
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final image = response.data as Uint8List;
        return Right(image);
      } else {
        return Left(ServerFailure(response.statusMessage ?? ''));
      }
    } on DioException catch (e) {
      logger.e(
        "[CustomApiService.getLoremPicsumImage]: ${e.message}",
        error: e.error,
        stackTrace: e.stackTrace,
      );
      return Left(ServerFailure(e.message ?? ''));
    } catch (e) {
      logger.e(
        "[CustomApiService.getLoremPicsumImage]: ${e.toString()}",
      );
      return Left(UnknownFailure(e.toString()));
    }
  }
}
