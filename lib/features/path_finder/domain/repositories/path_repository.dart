import '../entities/path_result.dart';
import '../entities/path_task.dart';

abstract interface class PathRepository {
  Future<List<PathTask>> fetchTasks();

  Future<void> sendResults(List<PathResult> results);
}
