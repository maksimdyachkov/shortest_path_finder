// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiResponse', json, ($checkedConvert) {
      final val = ApiResponse(
        error: $checkedConvert('error', (v) => v as bool),
        message: $checkedConvert('message', (v) => v as String?),
        data: $checkedConvert('data', (v) => v),
      );
      return val;
    });
