import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import '../error/exceptions.dart';

part 'api_response.g.dart';

/// The envelope every API answer is wrapped in:
/// `{"error": bool, "message": String, "data": ...}`.
@JsonSerializable(checked: true, createToJson: false)
class ApiResponse {
  const ApiResponse({required this.error, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  /// Reads a successful answer of the API.
  /// Throws [ServerException] when the answer is unreadable or reports an error.
  factory ApiResponse.fromHttp(http.Response httpResponse) {
    final ApiResponse response;
    try {
      final json = jsonDecode(httpResponse.body);
      if (json is! Map<String, dynamic>) {
        throw const FormatException('The response is not a JSON object');
      }
      response = ApiResponse.fromJson(json);
    } on Exception {
      throw const ServerException();
    }

    final isOk =
        httpResponse.statusCode >= HttpStatus.ok &&
        httpResponse.statusCode < HttpStatus.multipleChoices;
    if (!isOk || response.error) throw ServerException(response.errorMessage);

    return response;
  }

  final bool error;
  final String? message;
  final Object? data;

  /// The explanation of a failed request, if the server gave one.
  /// Validation errors come in `data.message` with an empty [message].
  String? get errorMessage {
    if (message case final text? when text.isNotEmpty) return text;
    if (data case {'message': final String text} when text.isNotEmpty) {
      return text;
    }
    return null;
  }
}
