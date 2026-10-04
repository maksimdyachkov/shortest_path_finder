// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathTaskModel _$PathTaskModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PathTaskModel', json, ($checkedConvert) {
      final val = PathTaskModel(
        id: $checkedConvert('id', (v) => v as String),
        field: $checkedConvert(
          'field',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        start: $checkedConvert(
          'start',
          (v) => CellModel.fromJson(v as Map<String, dynamic>),
        ),
        end: $checkedConvert(
          'end',
          (v) => CellModel.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });
