import '../../../../core/error/exceptions.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/entities/path_task.dart';
import '../../domain/repositories/path_repository.dart';
import '../datasources/api_url_local_data_source.dart';
import '../datasources/path_remote_data_source.dart';
import '../models/path_result_model.dart';

class PathRepositoryImpl implements PathRepository {
  const PathRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final PathRemoteDataSource _remoteDataSource;
  final ApiUrlLocalDataSource _localDataSource;

  /// Both requests go to the url saved on the home screen.
  Uri get _url {
    final url = _localDataSource.readUrl();
    if (url == null) throw const MissingUrlException();
    return Uri.parse(url);
  }

  @override
  Future<List<PathTask>> fetchTasks() async {
    final models = await _remoteDataSource.getTasks(_url);
    return [for (final model in models) model.toEntity()];
  }

  @override
  Future<void> sendResults(List<PathResult> results) {
    final models = results.map(PathResultModel.fromEntity).toList();
    return _remoteDataSource.postResults(_url, models);
  }
}
