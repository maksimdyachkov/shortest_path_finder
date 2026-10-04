import '../constants/app_strings.dart';

sealed class AppException implements Exception {
  const AppException();

  /// The text shown to the user for this error.
  String get userMessage;
}

/// The server answered, but with an error or an unreadable body.
final class ServerException extends AppException {
  const ServerException([this.message]);

  /// The explanation sent by the server, if any.
  final String? message;

  @override
  String get userMessage => message ?? AppStrings.errorUnexpected;
}

/// The server could not be reached.
final class NetworkException extends AppException {
  const NetworkException();

  @override
  String get userMessage => AppStrings.errorNoConnection;
}

/// A request was attempted before the API url was saved.
final class MissingUrlException extends AppException {
  const MissingUrlException();

  @override
  String get userMessage => AppStrings.errorMissingUrl;
}
