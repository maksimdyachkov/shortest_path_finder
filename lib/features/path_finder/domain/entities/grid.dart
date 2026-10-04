import 'package:equatable/equatable.dart';

class Grid extends Equatable {
  const Grid(this.rows);

  final List<String> rows;

  @override
  List<Object?> get props => [rows];
}
