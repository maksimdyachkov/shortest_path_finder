import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_response.dart';

/// Sends requests to the API and returns its successful answers.
class ApiClient {
  const ApiClient(this._client);

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  final http.Client _client;

  Future<ApiResponse> get(Uri url) async =>
      ApiResponse.fromHttp(await _client.get(url));

  Future<ApiResponse> post(Uri url, Object? body) async => ApiResponse.fromHttp(
    await _client.post(url, headers: _jsonHeaders, body: jsonEncode(body)),
  );
}
