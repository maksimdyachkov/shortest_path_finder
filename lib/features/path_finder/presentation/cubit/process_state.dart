import 'package:equatable/equatable.dart';

import '../../domain/entities/path_result.dart';

sealed class ProcessState extends Equatable {
  const ProcessState(this.percent);

  static const minPercent = 0;
  static const maxPercent = 100;

  /// The share of solved tasks shown on the screen.
  final int percent;

  @override
  List<Object?> get props => [percent];
}

/// The task list is being fetched.
final class ProcessLoading extends ProcessState {
  const ProcessLoading() : super(ProcessState.minPercent);
}

final class ProcessLoadFailure extends ProcessState {
  const ProcessLoadFailure(this.message) : super(ProcessState.minPercent);

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

final class ProcessCalculating extends ProcessState {
  const ProcessCalculating(super.percent);
}

/// All tasks are solved and [results] can be sent to the server.
sealed class ProcessCalculated extends ProcessState {
  const ProcessCalculated(this.results) : super(ProcessState.maxPercent);

  final List<PathResult> results;

  @override
  List<Object?> get props => [...super.props, results];
}

final class ProcessReady extends ProcessCalculated {
  const ProcessReady(super.results, {this.errorMessage});

  /// Set when the previous attempt to send the results failed.
  final String? errorMessage;

  @override
  List<Object?> get props => [...super.props, errorMessage];
}

final class ProcessSending extends ProcessCalculated {
  const ProcessSending(super.results);
}

final class ProcessSent extends ProcessCalculated {
  const ProcessSent(super.results);
}
