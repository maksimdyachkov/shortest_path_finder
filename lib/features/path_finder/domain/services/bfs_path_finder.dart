import 'dart:collection';

import '../entities/cell.dart';
import '../entities/grid.dart';
import 'path_finder.dart';

/// Breadth-first search. The search spreads from the start one step at a
/// time in all eight directions, so the first time it reaches the end cell
/// the path that led there is the shortest one.
class BfsPathFinder implements PathFinder {
  const BfsPathFinder();

  static const _directions = [
    Cell(-1, -1),
    Cell(0, -1),
    Cell(1, -1),
    Cell(-1, 0),
    Cell(1, 0),
    Cell(-1, 1),
    Cell(0, 1),
    Cell(1, 1),
  ];

  @override
  List<Cell> findPath(Grid grid, Cell start, Cell end) {
    if (!grid.isWalkable(start) || !grid.isWalkable(end)) return const [];
    if (start == end) return [start];

    final visited = {start};
    // For every reached cell: the cell the search came from.
    final previous = <Cell, Cell>{};
    final queue = Queue<Cell>()..add(start);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();

      for (final direction in _directions) {
        final next = Cell(current.x + direction.x, current.y + direction.y);
        if (!grid.isWalkable(next) || visited.contains(next)) continue;

        visited.add(next);
        previous[next] = current;
        if (next == end) return _pathTo(end, previous);
        queue.add(next);
      }
    }
    return const [];
  }

  /// Walks back from [end] to the start and returns the cells in travel order.
  List<Cell> _pathTo(Cell end, Map<Cell, Cell> previous) {
    final path = <Cell>[];
    for (Cell? cell = end; cell != null; cell = previous[cell]) {
      path.add(cell);
    }
    return path.reversed.toList();
  }
}
