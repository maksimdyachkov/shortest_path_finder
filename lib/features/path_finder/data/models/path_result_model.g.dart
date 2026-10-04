// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PathResultModelToJson(PathResultModel instance) =>
    <String, dynamic>{'id': instance.id, 'result': instance.result.toJson()};

Map<String, dynamic> _$PathSolutionModelToJson(PathSolutionModel instance) =>
    <String, dynamic>{
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'path': instance.path,
    };
