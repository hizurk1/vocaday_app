import 'package:cloud_firestore/cloud_firestore.dart';
import "package:connectivity_plus/connectivity_plus.dart";
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

import 'app/managers/api.dart';
import 'app/managers/cloud_storage.dart';
import 'app/managers/connection.dart';
import 'app/managers/language.dart';
import 'app/managers/shared_preferences.dart';
import 'app/managers/theme.dart';
import 'app/routes/route_manager.dart';
import 'features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/auth_state_changed.dart';
import 'features/authentication/domain/usecases/change_password.dart';
import 'features/authentication/domain/usecases/delete_account.dart';
import 'features/authentication/domain/usecases/re_authentication.dart';
import 'features/authentication/domain/usecases/send_code_to_email.dart';
import 'features/authentication/domain/usecases/sign_in_with_email_password.dart';
import 'features/authentication/domain/usecases/sign_in_with_google.dart';
import 'features/authentication/domain/usecases/sign_out.dart';
import 'features/authentication/domain/usecases/sign_up_with_email_password.dart';
import 'features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'features/authentication/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'features/authentication/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'features/mini_game/data/data_sources/game_remote_data_source.dart';
import 'features/mini_game/data/repositories/game_repository_impl.dart';
import 'features/mini_game/domain/repositories/game_repository.dart';
import 'features/mini_game/domain/usecases/update_user_gold.dart';
import 'features/mini_game/domain/usecases/update_user_point.dart';
import 'features/mini_game/presentation/cubits/quiz/game_quiz_cubit.dart';
import 'features/user/user_cart/data/data_sources/cart_remote_data_source.dart';
import 'features/user/user_cart/data/repositories/cart_repository_impl.dart';
import 'features/user/user_cart/domain/repositories/cart_repository.dart';
import 'features/user/user_cart/domain/usecases/add_cart_bag.dart';
import 'features/user/user_cart/domain/usecases/create_cart.dart';
import 'features/user/user_cart/domain/usecases/delete_cart_bag.dart';
import 'features/user/user_cart/domain/usecases/expand_cart_bag.dart';
import 'features/user/user_cart/domain/usecases/get_cart.dart';
import 'features/user/user_cart/domain/usecases/update_cart_bag.dart';
import 'features/user/user_cart/presentation/cubits/cart/cart_cubit.dart';
import 'features/user/user_cart/presentation/cubits/cart_bag/cart_bag_cubit.dart';
import 'features/user/user_profile/data/data_sources/user_remote_data_source.dart';
import 'features/user/user_profile/data/repositories/user_repository_impl.dart';
import 'features/user/user_profile/domain/repositories/user_repository.dart';
import 'features/user/user_profile/domain/usecases/add_attendance_date.dart';
import 'features/user/user_profile/domain/usecases/add_known_words.dart';
import 'features/user/user_profile/domain/usecases/get_list_users.dart';
import 'features/user/user_profile/domain/usecases/get_user_data.dart';
import 'features/user/user_profile/domain/usecases/remove_all_favourite_word_usecase.dart';
import 'features/user/user_profile/domain/usecases/remove_all_known_word.dart';
import 'features/user/user_profile/domain/usecases/sync_favourite_word_usecase.dart';
import 'features/user/user_profile/domain/usecases/sync_known_word.dart';
import 'features/user/user_profile/domain/usecases/update_user_profile.dart';
import 'features/user/user_profile/presentation/cubits/favourite/word_favourite_cubit.dart';
import 'features/user/user_profile/presentation/cubits/known/known_word_cubit.dart';
import 'features/user/user_profile/presentation/cubits/leader_board/leader_board_cubit.dart';
import 'features/user/user_profile/presentation/cubits/user_data/user_data_cubit.dart';
import 'features/word/data/data_sources/word_local_data_source.dart';
import 'features/word/data/repositories/word_repository_impl.dart';
import 'features/word/domain/repositories/word_repository.dart';
import 'features/word/domain/usecases/get_all_words.dart';
import 'features/word/domain/usecases/search_words.dart';
import 'features/word/presentation/blocs/search_word/search_word_bloc.dart';
import 'features/word/presentation/blocs/word_list/word_list_cubit.dart';

final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {
  //! External
  sl.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  await sl.isReady<SharedPreferences>();
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  //! App
  sl.registerLazySingleton(() => SharedPrefManager(sl()));
  sl.registerLazySingleton(() => CloudStorageService(sl()));
  sl.registerLazySingleton(() => CustomApiService(sl()));
  sl.registerLazySingleton(() => AppRouter());
  sl.registerFactory(() => ThemeCubit(sl()));
  sl.registerFactory(() => LanguageCubit());
  sl.registerFactory(() => ConnectionCubit(sl()));

  //! Features - favourite
  // Usecase
  sl.registerLazySingleton(() => SyncFavouriteWordUsecase(repository: sl()));
  sl.registerLazySingleton(() => RemoveAllFavouriteWordUsecase(sl()));
  // Cubit
  sl.registerFactory(() => WordFavouriteCubit(sl(), sl(), sl(), sl()));

  //! Features - known
  // Usecase
  sl.registerLazySingleton(() => AddKnownWordsUsecase(sl(), sl()));
  sl.registerLazySingleton(() => SyncKnownWordUsecase(sl()));
  sl.registerLazySingleton(() => RemoveAllKnownWordUsecase(sl()));
  // Cubit
  sl.registerFactory(() => KnownWordCubit(sl(), sl(), sl(), sl(), sl()));

  //! Features - word
  // Data source
  sl.registerLazySingleton<WordLocalDataSource>(
    () => WordLocalDataSourceImpl(),
  );
  // Repository
  sl.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(localDataSource: sl()),
  );
  // Usecase
  sl.registerLazySingleton(() => GetAllWordsUsecase(repository: sl()));
  sl.registerLazySingleton(() => SearchWordsUsecase(repository: sl()));
  // Bloc
  sl.registerFactory(() => WordListCubit(sl()));
  sl.registerFactory(() => SearchWordBloc(sl()));

  //! Features - authentication
  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  // Usecase
  sl.registerLazySingleton(
    () => AuthStateChangedUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SignOutUsecase(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => SignUpWithEmailPasswordUsecase(
      authRepository: sl(),
      userRepository: sl(),
      cartRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SignInWithEmailPasswordUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SignInWithGoogleUsecase(
      authRepository: sl(),
      userRepository: sl(),
      cartRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ReAuthenticationUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => ChangePasswordUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => SendCodeToEmailUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => DeleteAccountUsecase(sl(), sl(), sl(), sl(), sl()),
  );
  // Bloc
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => SignInBloc(sl(), sl()));
  sl.registerFactory(() => SignUpBloc(sl()));

  //! Features - user
  // Data source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );
  // Usecase
  sl.registerLazySingleton(
    () => UpdateUserProfileUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetUserDataUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => AddAttendanceDateUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetListUsersUsecase(repository: sl()),
  );
  // Bloc/Cubit
  sl.registerFactory(() => UserDataCubit(sl(), sl(), sl()));
  sl.registerFactory(() => LeaderBoardCubit(sl()));

  //! Feature: Cart
  // Data source
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl()),
  );
  // Usecase
  sl.registerLazySingleton(() => AddCartUsecase(sl()));
  sl.registerLazySingleton(() => AddCartBagUsecase(sl()));
  sl.registerLazySingleton(() => GetCartUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCartBagUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCartBagUsecase(sl()));
  sl.registerLazySingleton(() => ExpandCartBagUsecase(sl(), sl()));
  // Bloc/Cubit
  sl.registerFactory(() => CartBagCubit(sl()));
  sl.registerFactory(() => CartCubit(sl(), sl(), sl(), sl(), sl(), sl()));

  //! Feature - game
  // Data source
  sl.registerLazySingleton<GameRemoteDataSource>(
    () => GameRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<GameRepository>(() => GameRepositoryImpl(sl()));
  // Usecase
  sl.registerLazySingleton(() => UpdateUserPointUsecase(sl()));
  sl.registerLazySingleton(() => UpdateUserGoldUsecase(sl()));
  // Cubit
  sl.registerFactory(() => GameQuizCubit(sl(), sl()));
}
