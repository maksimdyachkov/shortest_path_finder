import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/core/constants/app_colors.dart';
import 'package:shortest_path_finder/core/constants/app_strings.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_task.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/pages/result_list_page.dart';

void main() {
  const result = PathResult(
    task: PathTask(
      id: 'id',
      grid: Grid(['.X.', '.X.', '...']),
      start: Cell(2, 1),
      end: Cell(0, 2),
    ),
    steps: [Cell(2, 1), Cell(1, 2), Cell(0, 2)],
  );

  Color? colorOf(WidgetTester tester, String label) {
    final cell = tester.widget<Container>(
      find.ancestor(of: find.text(label), matching: find.byType(Container)),
    );
    return (cell.decoration! as BoxDecoration).color;
  }

  testWidgets('a tap on a result opens its grid with the coloured path', (
    tester,
  ) async {
    // A phone-sized screen, so the whole 3x3 grid is visible.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: ResultListPage(results: [result])),
    );

    await tester.tap(find.text('(2,1)->(1,2)->(0,2)'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.previewTitle), findsOneWidget);
    expect(find.text('(2,1)->(1,2)->(0,2)'), findsOneWidget);
    expect(colorOf(tester, '(2,1)'), AppColors.cellStart);
    expect(colorOf(tester, '(0,2)'), AppColors.cellEnd);
    expect(colorOf(tester, '(1,2)'), AppColors.cellPath);
    expect(colorOf(tester, '(1,0)'), AppColors.cellBlocked);
    expect(colorOf(tester, '(0,0)'), AppColors.cellEmpty);
  });
}
