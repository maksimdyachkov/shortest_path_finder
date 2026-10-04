import 'package:equatable/equatable.dart';

import 'cell.dart';
import 'cell_type.dart';
import 'path_task.dart';

class PathResult extends Equatable {
  const PathResult({required this.task, required this.steps});

  static const _stepSeparator = '->';

  final PathTask task;

  /// Cells from start to end inclusive; empty when the end is unreachable.
  final List<Cell> steps;

  String get path => steps.map((cell) => cell.label).join(_stepSeparator);

  CellType typeOf(Cell cell) {
    if (cell == task.start) return CellType.start;
    if (cell == task.end) return CellType.end;
    if (task.grid.isBlocked(cell)) return CellType.blocked;
    if (steps.contains(cell)) return CellType.path;
    return CellType.empty;
  }

  @override
  List<Object?> get props => [task, steps];
}
