import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/cell.dart';

part 'cell_model.g.dart';

@JsonSerializable(checked: true)
class CellModel {
  const CellModel({required this.x, required this.y});

  factory CellModel.fromJson(Map<String, dynamic> json) =>
      _$CellModelFromJson(json);

  factory CellModel.fromEntity(Cell cell) => CellModel(x: cell.x, y: cell.y);

  final int x;
  final int y;

  Map<String, dynamic> toJson() => _$CellModelToJson(this);

  Cell toEntity() => Cell(x, y);
}
