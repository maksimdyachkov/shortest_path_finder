import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/path_result_model.dart';
import '../models/path_task_model.dart';

abstract interface class PathRemoteDataSource {
  Future<List<PathTaskModel>> getTasks(Uri url);

  Future<void> postResults(Uri url, List<PathResultModel> results);
}

class PathRemoteDataSourceImpl implements PathRemoteDataSource {
  const PathRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<PathTaskModel>> getTasks(Uri url) async {
    final response = await _apiClient.get(url);
    final data = response.data;
    if (data is! List) throw const ServerException();

    return [for (final task in data) _taskFromJson(task)];
  }

  @override
  Future<void> postResults(Uri url, List<PathResultModel> results) async {
    await _apiClient.post(url, results);
  }

  PathTaskModel _taskFromJson(Object? json) {
    if (json is! Map<String, dynamic>) throw const ServerException();

    try {
      return PathTaskModel.fromJson(json);
    } on Exception {
      throw const ServerException();
    }
  }
}
