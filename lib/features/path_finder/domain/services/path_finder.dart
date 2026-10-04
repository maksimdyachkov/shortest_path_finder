import '../entities/cell.dart';
import '../entities/grid.dart';

abstract interface class PathFinder {
  /// Returns the cells from [start] to [end] inclusive,
  /// or an empty list when [end] is unreachable.
  List<Cell> findPath(Grid grid, Cell start, Cell end);
}
