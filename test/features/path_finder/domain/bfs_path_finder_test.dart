import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/services/bfs_path_finder.dart';

void main() {
  const finder = BfsPathFinder();

  /// Every step moves to a walkable neighbour (8 directions).
  void expectValidPath(Grid grid, List<Cell> path) {
    for (var i = 0; i < path.length; i++) {
      expect(grid.isWalkable(path[i]), true);
      if (i == 0) continue;
      final dx = (path[i].x - path[i - 1].x).abs();
      final dy = (path[i].y - path[i - 1].y).abs();
      expect(dx <= 1 && dy <= 1 && dx + dy > 0, true);
    }
  }

  test('solves the example from the task description', () {
    const grid = Grid(['.X.', '.X.', '...']);

    final path = finder.findPath(grid, const Cell(1, 2), const Cell(2, 0));

    expect(path, const [Cell(1, 2), Cell(2, 1), Cell(2, 0)]);
  });

  test('solves the 3x3 task returned by the API', () {
    const grid = Grid(['.X.', '.X.', '...']);

    final path = finder.findPath(grid, const Cell(2, 1), const Cell(0, 2));

    expect(path, const [Cell(2, 1), Cell(1, 2), Cell(0, 2)]);
  });

  test('solves the 4x4 task returned by the API', () {
    const grid = Grid(['XXX.', 'X..X', 'X..X', '.XXX']);

    final path = finder.findPath(grid, const Cell(0, 3), const Cell(3, 0));

    expect(path, const [Cell(0, 3), Cell(1, 2), Cell(2, 1), Cell(3, 0)]);
  });

  test('goes around a wall using the minimal number of steps', () {
    const grid = Grid(['.X...', '.X.X.', '.X.X.', '.X.X.', '...X.']);

    final path = finder.findPath(grid, const Cell(0, 0), const Cell(4, 4));

    expect(path.first, const Cell(0, 0));
    expect(path.last, const Cell(4, 4));
    expect(path.length, 13);
    expectValidPath(grid, path);
  });

  test('returns a single cell when start equals end', () {
    const grid = Grid(['..', '..']);

    expect(finder.findPath(grid, const Cell(1, 1), const Cell(1, 1)), const [
      Cell(1, 1),
    ]);
  });

  test('returns an empty path when the end is unreachable', () {
    const grid = Grid(['.X.', '.X.', '.X.']);

    expect(finder.findPath(grid, const Cell(0, 0), const Cell(2, 2)), isEmpty);
  });

  test('returns an empty path when start or end is blocked or outside', () {
    const grid = Grid(['X.', '..']);

    expect(finder.findPath(grid, const Cell(0, 0), const Cell(1, 1)), isEmpty);
    expect(finder.findPath(grid, const Cell(1, 1), const Cell(0, 0)), isEmpty);
    expect(finder.findPath(grid, const Cell(1, 1), const Cell(2, 2)), isEmpty);
  });

  test('crosses the largest allowed grid along the diagonal', () {
    const size = 99;
    final grid = Grid(List.filled(size, '.' * size));

    final path = finder.findPath(
      grid,
      const Cell(0, 0),
      const Cell(size - 1, size - 1),
    );

    expect(path.length, size);
    expectValidPath(grid, path);
  });
}
