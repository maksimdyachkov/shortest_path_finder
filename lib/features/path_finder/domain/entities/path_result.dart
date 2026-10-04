import 'package:equatable/equatable.dart';

import 'cell.dart';
import 'path_task.dart';

class PathResult extends Equatable {
  const PathResult({required this.task, required this.steps});

  static const _stepSeparator = '->';

  final PathTask task;

  /// Cells from start to end inclusive; empty when the end is unreachable.
  final List<Cell> steps;

  String get path => steps.map((cell) => cell.label).join(_stepSeparator);

  @override
  List<Object?> get props => [task, steps];
}
