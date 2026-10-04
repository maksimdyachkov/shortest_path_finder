import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_durations.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/path_result.dart';
import '../../domain/repositories/path_repository.dart';
import '../../domain/usecases/task_solver.dart';
import 'process_state.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit(
    this._repository,
    this._taskSolver, {
    this.percentStep = AppDurations.percentStep,
  }) : super(const ProcessLoading());

  final PathRepository _repository;
  final TaskSolver _taskSolver;
  final Duration percentStep;

  /// Loads the tasks and solves them one by one, showing the progress.
  Future<void> start() async {
    emit(const ProcessLoading());
    try {
      final tasks = await _repository.fetchTasks();

      final results = <PathResult>[];
      for (final task in tasks) {
        results.add(_taskSolver.solve(task));
        await _showProgress(solved: results.length, total: tasks.length);
      }

      emit(ProcessReady(results));
    } on AppException catch (exception) {
      emit(ProcessLoadFailure(exception.userMessage));
    }
  }

  /// Sends the calculated results; does nothing until they are ready.
  Future<void> sendResults() async {
    final current = state;
    if (current is! ProcessCalculated) return;

    final results = current.results;
    emit(ProcessSending(results));
    try {
      await _repository.sendResults(results);
      emit(ProcessSent(results));
    } on AppException catch (exception) {
      emit(ProcessReady(results, errorMessage: exception.userMessage));
    }
  }

  /// Raises the percent to the share of solved tasks one point at a time.
  /// Solving takes milliseconds, so without the steps it would jump to 100.
  Future<void> _showProgress({required int solved, required int total}) async {
    final solvedPercent = solved * ProcessState.maxPercent ~/ total;

    for (var percent = state.percent + 1; percent <= solvedPercent; percent++) {
      emit(ProcessCalculating(percent));
      await Future<void>.delayed(percentStep);
    }
  }

  /// The user can leave the page while a request or the calculation is still
  /// running, so states emitted after closing are ignored instead of throwing.
  @override
  void emit(ProcessState state) {
    if (!isClosed) super.emit(state);
  }
}
