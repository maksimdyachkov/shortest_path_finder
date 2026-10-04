import 'package:equatable/equatable.dart';

import 'cell.dart';

/// A square field of `.` (free) and `X` (blocked) cells.
class Grid extends Equatable {
  const Grid(this.rows);

  static const blockedSymbol = 'X';

  final List<String> rows;

  int get size => rows.length;

  bool contains(Cell cell) =>
      cell.y >= 0 &&
      cell.y < size &&
      cell.x >= 0 &&
      cell.x < size &&
      cell.x < rows[cell.y].length;

  bool isBlocked(Cell cell) => rows[cell.y][cell.x] == blockedSymbol;

  bool isWalkable(Cell cell) => contains(cell) && !isBlocked(cell);

  @override
  List<Object?> get props => [rows];
}
