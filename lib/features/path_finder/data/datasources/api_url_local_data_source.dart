import 'package:shared_preferences/shared_preferences.dart';

class ApiUrlLocalDataSource {
  const ApiUrlLocalDataSource(this._preferences);

  static const _urlKey = 'api_url';

  final SharedPreferences _preferences;

  String? readUrl() => _preferences.getString(_urlKey);

  Future<void> writeUrl(String url) => _preferences.setString(_urlKey, url);
}
