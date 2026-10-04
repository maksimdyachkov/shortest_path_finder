import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/core/constants/app_strings.dart';
import 'package:shortest_path_finder/core/error/exceptions.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_task.dart';
import 'package:shortest_path_finder/features/path_finder/domain/repositories/path_repository.dart';
import 'package:shortest_path_finder/features/path_finder/domain/usecases/task_solver.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/cubit/process_cubit.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/cubit/process_state.dart';

class _FakePathRepository implements PathRepository {
  List<PathTask> tasks = const [];
  AppException? fetchError;
  AppException? sendError;
  List<PathResult>? sent;

  @override
  Future<List<PathTask>> fetchTasks() async {
    if (fetchError case final error?) throw error;
    return tasks;
  }

  @override
  Future<void> sendResults(List<PathResult> results) async {
    if (sendError case final error?) throw error;
    sent = results;
  }
}

void main() {
  const first = PathTask(
    id: 'first',
    grid: Grid(['.X.', '.X.', '...']),
    start: Cell(2, 1),
    end: Cell(0, 2),
  );
  const second = PathTask(
    id: 'second',
    grid: Grid(['XXX.', 'X..X', 'X..X', '.XXX']),
    start: Cell(0, 3),
    end: Cell(3, 0),
  );
  const results = [
    PathResult(task: first, steps: []),
    PathResult(task: second, steps: []),
  ];

  late _FakePathRepository repository;
  late ProcessCubit cubit;

  setUp(() {
    repository = _FakePathRepository()..tasks = const [first, second];
    cubit = ProcessCubit(
      repository,
      const TaskSolver(),
      percentStep: Duration.zero,
    );
  });

  test(
    'raises the percent point by point and finishes with the results',
    () async {
      final states = expectLater(
        cubit.stream,
        emitsInOrder([
          const ProcessLoading(),
          for (var percent = 1; percent <= 100; percent++)
            ProcessCalculating(percent),
          const ProcessReady(results),
        ]),
      );

      await cubit.start();

      await states;
    },
  );

  test('finishes with no results when the server has no tasks', () async {
    repository.tasks = const [];

    await cubit.start();

    expect(cubit.state, const ProcessReady([]));
  });

  test('shows the server message when tasks cannot be loaded', () async {
    repository.fetchError = const ServerException('Too Many Requests');

    await cubit.start();

    expect(cubit.state, const ProcessLoadFailure('Too Many Requests'));
  });

  test('shows a connection message when the server is unreachable', () async {
    repository.fetchError = const NetworkException();

    await cubit.start();

    expect(cubit.state, const ProcessLoadFailure(AppStrings.errorNoConnection));
  });

  test('sends the results and reports success', () async {
    await cubit.start();
    final states = expectLater(
      cubit.stream,
      emitsInOrder(const [ProcessSending(results), ProcessSent(results)]),
    );

    await cubit.sendResults();

    await states;
    expect(repository.sent, results);
  });

  test('returns to the ready state with an error when sending fails', () async {
    await cubit.start();
    repository.sendError = const ServerException();

    await cubit.sendResults();

    expect(
      cubit.state,
      const ProcessReady(results, errorMessage: AppStrings.errorUnexpected),
    );
  });

  test('does nothing when closed before the tasks arrive', () async {
    final start = cubit.start();
    await cubit.close();

    await start;

    expect(cubit.state, const ProcessLoading());
  });
}
