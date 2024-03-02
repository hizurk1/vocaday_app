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
import 'features/authentication/domain/usecases/re_authentication.dart';
import 'features/authentication/domain/usecases/send_code_to_email.dart';
import 'features/authentication/domain/usecases/sign_in_with_email_password.dart';
import 'features/authentication/domain/usecases/sign_in_with_google.dart';
import 'features/authentication/domain/usecases/sign_out.dart';
import 'features/authentication/domain/usecases/sign_up_with_email_password.dart';
import 'features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'features/authentication/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'features/authentication/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'features/favourite/domain/usecases/remove_all_favourite_word_usecase.dart';
import 'features/favourite/domain/usecases/sync_favourite_word_usecase.dart';
import 'features/favourite/presentation/cubit/word_favourite_cubit.dart';
import 'features/user/data/data_sources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/add_attendance_date.dart';
import 'features/user/domain/usecases/get_list_users.dart';
import 'features/user/domain/usecases/get_user_data.dart';
import 'features/user/domain/usecases/update_user_profile.dart';
import 'features/user/presentation/cubits/leader_board/leader_board_cubit.dart';
import 'features/user/presentation/cubits/user_data/user_data_cubit.dart';
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
  sl.registerFactory(() => WordFavouriteCubit(sl(), sl(), sl()));

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
    () => SignOutUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SignUpWithEmailPasswordUsecase(
      authRepository: sl(),
      userRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SignInWithEmailPasswordUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SignInWithGoogleUsecase(
      authRepository: sl(),
      userRepository: sl(),
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
  // Bloc
  sl.registerFactory(() => AuthBloc(sl(), sl(), sl(), sl()));
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
}
