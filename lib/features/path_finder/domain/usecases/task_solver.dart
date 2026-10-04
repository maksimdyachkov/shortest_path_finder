import '../entities/path_result.dart';
import '../entities/path_task.dart';
import '../services/path_finder.dart';

class TaskSolver {
  const TaskSolver(this._pathFinder);

  final PathFinder _pathFinder;

  /// Finds the shortest path for [task].
  PathResult solve(PathTask task) => PathResult(
    task: task,
    steps: _pathFinder.findPath(task.grid, task.start, task.end),
  );
}
