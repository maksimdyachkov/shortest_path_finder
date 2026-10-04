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

      _emitIfOpen(ProcessReady(results));
    } on AppException catch (exception) {
      _emitIfOpen(ProcessLoadFailure(exception.userMessage));
    }
  }

  /// Sends the calculated results. Does nothing until they are ready
  /// or while a previous sending is still in progress.
  Future<void> sendResults() async {
    final current = state;
    if (current is! ProcessCalculated || current is ProcessSending) return;

    final results = current.results;
    emit(ProcessSending(results));
    try {
      await _repository.sendResults(results);
      _emitIfOpen(ProcessSent(results));
    } on AppException catch (exception) {
      _emitIfOpen(ProcessReady(results, errorMessage: exception.userMessage));
    }
  }

  /// Raises the percent to the share of solved tasks one point at a time.
  /// Solving takes milliseconds, so without the steps it would jump to 100.
  Future<void> _showProgress({required int solved, required int total}) async {
    final solvedPercent = solved * ProcessState.maxPercent ~/ total;

    for (var percent = state.percent + 1; percent <= solvedPercent; percent++) {
      _emitIfOpen(ProcessCalculating(percent));
      await Future<void>.delayed(percentStep);
    }
  }

  /// Emits [state] unless the cubit is already closed. Used after every
  /// `await`: the user can leave the page while a request or the calculation
  /// is still running, and emitting on a closed cubit throws.
  void _emitIfOpen(ProcessState state) {
    if (!isClosed) emit(state);
  }
}
