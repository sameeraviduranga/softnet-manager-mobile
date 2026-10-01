import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:softnetmanager/core/network/dio_client.dart';
import 'package:softnetmanager/core/router/auth_notifier.dart';
import 'package:softnetmanager/core/storage/token_storage_service.dart';
import 'package:softnetmanager/features/auth/cubit/auth_cubit.dart';
import 'package:softnetmanager/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:softnetmanager/features/auth/domain/repository/auth_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<TokenStorageService>()),
  );
  getIt.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      getIt<AuthRemoteDataSource>(),
      getIt<InternetConnectionChecker>(),
    ),
  );

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>(), getIt<TokenStorageService>()),
  );
  getIt.registerLazySingleton<AuthNotifier>(() => AuthNotifier());
}
