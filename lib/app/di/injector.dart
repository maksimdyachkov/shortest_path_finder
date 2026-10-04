import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_client.dart';
import '../../core/utils/url_validator.dart';
import '../../features/path_finder/data/datasources/api_url_local_data_source.dart';
import '../../features/path_finder/data/datasources/path_remote_data_source.dart';
import '../../features/path_finder/data/repositories/api_url_repository_impl.dart';
import '../../features/path_finder/data/repositories/path_repository_impl.dart';
import '../../features/path_finder/domain/repositories/api_url_repository.dart';
import '../../features/path_finder/domain/repositories/path_repository.dart';
import '../../features/path_finder/domain/services/bfs_path_finder.dart';
import '../../features/path_finder/domain/services/path_finder.dart';
import '../../features/path_finder/domain/usecases/task_solver.dart';
import '../../features/path_finder/presentation/cubit/home_cubit.dart';
import '../../features/path_finder/presentation/cubit/process_cubit.dart';

final sl = GetIt.instance;

/// Registers every dependency of the app in the service locator.
class Injector {
  const Injector(this._locator);

  final GetIt _locator;

  Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();

    _registerCore();
    _registerData(preferences);
    _registerDomain();
    _registerCubits();
  }

  void _registerCore() {
    _locator
      ..registerLazySingleton(() => const UrlValidator())
      ..registerLazySingleton(() => ApiClient(NetworkClient(http.Client())));
  }

  void _registerData(SharedPreferences preferences) {
    _locator
      ..registerLazySingleton(() => ApiUrlLocalDataSource(preferences))
      ..registerLazySingleton<PathRemoteDataSource>(
        () => PathRemoteDataSourceImpl(_locator()),
      )
      ..registerLazySingleton<ApiUrlRepository>(
        () => ApiUrlRepositoryImpl(_locator()),
      )
      ..registerLazySingleton<PathRepository>(
        () => PathRepositoryImpl(_locator(), _locator()),
      );
  }

  void _registerDomain() {
    _locator
      ..registerLazySingleton<PathFinder>(() => const BfsPathFinder())
      ..registerLazySingleton(() => TaskSolver(_locator()));
  }

  void _registerCubits() {
    _locator
      ..registerFactory(() => HomeCubit(_locator(), _locator()))
      ..registerFactory(() => ProcessCubit(_locator(), _locator()));
  }
}
