import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/path_result.dart';
import 'cell_model.dart';

part 'path_result_model.g.dart';

@JsonSerializable(createFactory: false, explicitToJson: true)
class PathResultModel {
  const PathResultModel({required this.id, required this.result});

  factory PathResultModel.fromEntity(PathResult result) => PathResultModel(
    id: result.task.id,
    result: PathSolutionModel(
      steps: result.steps.map(CellModel.fromEntity).toList(),
      path: result.path,
    ),
  );

  final String id;
  final PathSolutionModel result;

  Map<String, dynamic> toJson() => _$PathResultModelToJson(this);
}

/// The `result` object of a sent task: the steps and the same path as text.
@JsonSerializable(createFactory: false, explicitToJson: true)
class PathSolutionModel {
  const PathSolutionModel({required this.steps, required this.path});

  final List<CellModel> steps;
  final String path;

  Map<String, dynamic> toJson() => _$PathSolutionModelToJson(this);
}
