// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CellModel _$CellModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CellModel', json, ($checkedConvert) {
      final val = CellModel(
        x: $checkedConvert('x', (v) => (v as num).toInt()),
        y: $checkedConvert('y', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CellModelToJson(CellModel instance) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
};
