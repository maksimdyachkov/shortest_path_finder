import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/app/di/injector.dart';
import 'package:shortest_path_finder/core/constants/app_durations.dart';
import 'package:shortest_path_finder/core/constants/app_strings.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_task.dart';
import 'package:shortest_path_finder/features/path_finder/domain/repositories/path_repository.dart';
import 'package:shortest_path_finder/features/path_finder/domain/services/bfs_path_finder.dart';
import 'package:shortest_path_finder/features/path_finder/domain/usecases/task_solver.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/cubit/process_cubit.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/pages/process_page.dart';

class _FakePathRepository implements PathRepository {
  final tasks = Completer<List<PathTask>>();

  @override
  Future<List<PathTask>> fetchTasks() => tasks.future;

  @override
  Future<void> sendResults(List<PathResult> results) async {}
}

void main() {
  const task = PathTask(
    id: 'id',
    grid: Grid(['..', '..']),
    start: Cell(0, 0),
    end: Cell(1, 1),
  );

  tearDown(sl.reset);

  testWidgets('the percent grows smoothly and the send button appears '
      'only when it reaches 100', (tester) async {
    // Created inside the test so that its futures run in the test's fake time.
    final repository = _FakePathRepository();
    sl.registerFactory(
      () => ProcessCubit(repository, const TaskSolver(BfsPathFinder())),
    );

    await tester.pumpWidget(const MaterialApp(home: ProcessPage()));

    expect(find.text(AppStrings.processLoading), findsOneWidget);
    expect(find.text(AppStrings.percent(0)), findsOneWidget);

    repository.tasks.complete(const [task]);
    await tester.pump();
    await tester.pump(AppDurations.percentStep * 50);

    expect(find.text(AppStrings.processCalculating), findsOneWidget);
    expect(find.text(AppStrings.processSendButton), findsNothing);

    await tester.pump(AppDurations.percentStep * 60);

    expect(find.text(AppStrings.processFinished), findsOneWidget);
    expect(find.text(AppStrings.percent(100)), findsOneWidget);
    expect(find.text(AppStrings.processSendButton), findsOneWidget);
  });
}
