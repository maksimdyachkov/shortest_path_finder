import '../../domain/repositories/api_url_repository.dart';
import '../datasources/api_url_local_data_source.dart';

class ApiUrlRepositoryImpl implements ApiUrlRepository {
  const ApiUrlRepositoryImpl(this._localDataSource);

  final ApiUrlLocalDataSource _localDataSource;

  @override
  String? getUrl() => _localDataSource.readUrl();

  @override
  Future<void> saveUrl(String url) => _localDataSource.writeUrl(url);
}
