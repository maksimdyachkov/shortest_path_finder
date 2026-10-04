import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// An HTTP client that never waits forever and reports
/// every transport failure as a [NetworkException].
class NetworkClient extends http.BaseClient {
  NetworkClient(this._inner);

  static const _timeout = Duration(seconds: 30);

  final http.Client _inner;

  /// Every request of the client (get, post, ...) goes through this method.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final response = await _inner.send(request).timeout(_timeout);
      final body = await response.stream.toBytes().timeout(_timeout);

      return http.StreamedResponse(
        http.ByteStream.fromBytes(body),
        response.statusCode,
        contentLength: body.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } on Exception {
      throw const NetworkException();
    }
  }

  @override
  void close() => _inner.close();
}
