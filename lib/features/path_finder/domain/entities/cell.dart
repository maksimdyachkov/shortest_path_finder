import 'package:equatable/equatable.dart';

class Cell extends Equatable {
  const Cell(this.x, this.y);

  /// Column index.
  final int x;

  /// Row index.
  final int y;

  /// The cell as it is written in a path, e.g. `(2,1)`.
  String get label => '($x,$y)';

  @override
  List<Object?> get props => [x, y];
}
