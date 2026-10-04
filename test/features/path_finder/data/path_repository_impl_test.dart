import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shortest_path_finder/core/error/exceptions.dart';
import 'package:shortest_path_finder/core/network/api_client.dart';
import 'package:shortest_path_finder/core/network/network_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortest_path_finder/features/path_finder/data/datasources/api_url_local_data_source.dart';
import 'package:shortest_path_finder/features/path_finder/data/datasources/path_remote_data_source.dart';
import 'package:shortest_path_finder/features/path_finder/data/repositories/path_repository_impl.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/cell.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/grid.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_result.dart';
import 'package:shortest_path_finder/features/path_finder/domain/entities/path_task.dart';

void main() {
  final url = Uri.parse('https://example.com/api?token=1');
  const task = PathTask(
    id: 'id-1',
    grid: Grid(['.X.', '.X.', '...']),
    start: Cell(2, 1),
    end: Cell(0, 2),
  );

  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'api_url': url.toString()});
    preferences = await SharedPreferences.getInstance();
  });

  PathRepositoryImpl repository(MockClientHandler handler) =>
      PathRepositoryImpl(
        PathRemoteDataSourceImpl(ApiClient(NetworkClient(MockClient(handler)))),
        ApiUrlLocalDataSource(preferences),
      );

  http.Response json(Object body, [int status = 200]) =>
      http.Response(jsonEncode(body), status);

  test('parses tasks and keeps the query parameters of the url', () async {
    late Uri requested;
    final source = repository((request) async {
      requested = request.url;
      return json({
        'error': false,
        'message': 'OK',
        'data': [
          {
            'id': 'id-1',
            'field': ['.X.', '.X.', '...'],
            'start': {'x': 2, 'y': 1},
            'end': {'x': 0, 'y': 2},
          },
        ],
      });
    });

    final tasks = await source.fetchTasks();

    expect(requested, url);
    expect(tasks, [task]);
  });

  test('sends results in the format expected by the API', () async {
    late http.Request sent;
    final source = repository((request) async {
      sent = request;
      return json({'error': false, 'message': 'OK', 'data': []});
    });

    await source.sendResults(const [
      PathResult(task: task, steps: [Cell(2, 1), Cell(1, 2), Cell(0, 2)]),
    ]);

    expect(sent.method, 'POST');
    expect(jsonDecode(sent.body), [
      {
        'id': 'id-1',
        'result': {
          'steps': [
            {'x': 2, 'y': 1},
            {'x': 1, 'y': 2},
            {'x': 0, 'y': 2},
          ],
          'path': '(2,1)->(1,2)->(0,2)',
        },
      },
    ]);
  });

  test('throws the server message on an error response', () {
    final source = repository(
      (_) async => json({
        'error': true,
        'message': 'Too Many Requests',
        'data': null,
      }, 429),
    );

    expect(
      source.fetchTasks(),
      throwsA(
        isA<ServerException>().having(
          (e) => e.message,
          'message',
          'Too Many Requests',
        ),
      ),
    );
  });

  test('treats a failed status code as an error even without the flag', () {
    final source = repository(
      (_) async => json({'error': false, 'message': 'Server is down'}, 500),
    );

    expect(
      source.sendResults(const []),
      throwsA(
        isA<ServerException>().having(
          (e) => e.message,
          'message',
          'Server is down',
        ),
      ),
    );
  });

  test('falls back to the validation details when message is empty', () {
    final source = repository(
      (_) async => json({
        'error': true,
        'message': '',
        'data': {'message': 'Validation failed'},
      }, 400),
    );

    expect(
      source.sendResults(const []),
      throwsA(
        isA<ServerException>().having(
          (e) => e.message,
          'message',
          'Validation failed',
        ),
      ),
    );
  });

  test('throws ServerException on an unreadable body', () {
    final notJson = repository((_) async => http.Response('<html>', 502));
    final wrongShape = repository(
      (_) async => json({
        'error': false,
        'data': [
          {'id': 1},
        ],
      }),
    );

    expect(notJson.fetchTasks(), throwsA(isA<ServerException>()));
    expect(wrongShape.fetchTasks(), throwsA(isA<ServerException>()));
  });

  test('throws ServerException when a task is not an object', () {
    final source = repository(
      (_) async => json({
        'error': false,
        'data': ['not a task'],
      }),
    );

    expect(source.fetchTasks(), throwsA(isA<ServerException>()));
  });

  test('throws ServerException when the answer is not the API envelope', () {
    final source = repository((_) async => json({'status': 'Not found'}, 404));

    expect(source.sendResults(const []), throwsA(isA<ServerException>()));
  });

  test('throws MissingUrlException when the url was never saved', () async {
    await preferences.clear();
    final source = repository((_) async => json({'error': false}));

    expect(source.fetchTasks, throwsA(isA<MissingUrlException>()));
  });

  test('throws NetworkException when the server is unreachable', () {
    final source = repository(
      (_) async => throw http.ClientException('Failed host lookup'),
    );

    expect(source.fetchTasks(), throwsA(isA<NetworkException>()));
  });
}
