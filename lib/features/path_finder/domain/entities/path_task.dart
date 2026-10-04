import 'package:equatable/equatable.dart';

import 'cell.dart';
import 'grid.dart';

class PathTask extends Equatable {
  const PathTask({
    required this.id,
    required this.grid,
    required this.start,
    required this.end,
  });

  final String id;
  final Grid grid;
  final Cell start;
  final Cell end;

  @override
  List<Object?> get props => [id, grid, start, end];
}
