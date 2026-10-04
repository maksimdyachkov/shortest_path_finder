import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/grid.dart';
import '../../domain/entities/path_task.dart';
import 'cell_model.dart';

part 'path_task_model.g.dart';

@JsonSerializable(checked: true, createToJson: false)
class PathTaskModel {
  const PathTaskModel({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory PathTaskModel.fromJson(Map<String, dynamic> json) =>
      _$PathTaskModelFromJson(json);

  final String id;
  final List<String> field;
  final CellModel start;
  final CellModel end;

  PathTask toEntity() => PathTask(
    id: id,
    grid: Grid(field),
    start: start.toEntity(),
    end: end.toEntity(),
  );
}
