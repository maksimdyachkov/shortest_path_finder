abstract interface class ApiUrlRepository {
  String? getUrl();

  Future<void> saveUrl(String url);
}
