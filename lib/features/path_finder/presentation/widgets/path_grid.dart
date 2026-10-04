import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/cell.dart';
import '../../domain/entities/cell_type.dart';
import '../../domain/entities/path_result.dart';

/// The grid of a solved task with the found path highlighted.
///
/// Small grids fill the width. Large ones keep the cells readable
/// and scroll in both directions; rows are built only when visible.
class PathGrid extends StatelessWidget {
  const PathGrid({super.key, required this.result});

  final PathResult result;

  @override
  Widget build(BuildContext context) {
    final size = result.task.grid.size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = max(constraints.maxWidth / size, AppSizes.cellMinSize);
        final side = cellSize * size;

        return SizedBox(
          height: side,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: side,
              child: ListView.builder(
                itemCount: size,
                itemExtent: cellSize,
                itemBuilder: (_, y) => Row(
                  children: [
                    for (var x = 0; x < size; x++)
                      _GridCell(
                        cell: Cell(x, y),
                        type: result.typeOf(Cell(x, y)),
                        size: cellSize,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.cell, required this.type, required this.size});

  final Cell cell;
  final CellType type;
  final double size;

  Color get _color => switch (type) {
    CellType.start => AppColors.cellStart,
    CellType.end => AppColors.cellEnd,
    CellType.blocked => AppColors.cellBlocked,
    CellType.path => AppColors.cellPath,
    CellType.empty => AppColors.cellEmpty,
  };

  Color get _textColor => type == CellType.blocked
      ? AppColors.cellTextOnBlocked
      : AppColors.cellText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(AppSizes.cellPadding),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _color,
        border: Border.all(
          color: AppColors.cellBorder,
          width: AppSizes.cellBorderWidth,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          cell.label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: _textColor),
        ),
      ),
    );
  }
}
