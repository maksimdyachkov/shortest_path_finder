import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell_type.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_task.dart';

void main() {
  const result = PathResult(
    task: PathTask(
      id: 'id',
      grid: Grid(['XXX.', 'X..X', 'X..X', '.XXX']),
      start: Cell(0, 3),
      end: Cell(3, 0),
    ),
    steps: [Cell(0, 3), Cell(1, 2), Cell(2, 1), Cell(3, 0)],
  );

  test('writes the path in the format of the task', () {
    expect(result.path, '(0,3)->(1,2)->(2,1)->(3,0)');
  });

  test('tells what every cell of the grid is', () {
    expect(result.typeOf(const Cell(0, 3)), CellType.start);
    expect(result.typeOf(const Cell(3, 0)), CellType.end);
    expect(result.typeOf(const Cell(1, 2)), CellType.path);
    expect(result.typeOf(const Cell(0, 0)), CellType.blocked);
    expect(result.typeOf(const Cell(1, 1)), CellType.empty);
  });
}
