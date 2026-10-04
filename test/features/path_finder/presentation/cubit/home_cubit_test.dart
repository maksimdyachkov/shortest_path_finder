import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/core/utils/url_validator.dart';
import 'package:shortest_path_finder/features/path_finder/domain/repositories/api_url_repository.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/cubit/home_cubit.dart';
import 'package:shortest_path_finder/features/path_finder/presentation/cubit/home_state.dart';

class _FakeApiUrlRepository implements ApiUrlRepository {
  _FakeApiUrlRepository([this.url]);

  String? url;

  @override
  String? getUrl() => url;

  int saveCount = 0;

  @override
  Future<void> saveUrl(String url) async {
    saveCount++;
    this.url = url;
  }
}

void main() {
  const validUrl = 'https://example.com/api?page=1';

  HomeCubit build(_FakeApiUrlRepository repository) =>
      HomeCubit(repository, const UrlValidator());

  test('starts with the previously saved url', () {
    final cubit = build(_FakeApiUrlRepository(validUrl));

    expect(cubit.state, const HomeInitial(validUrl));
  });

  test('reports an invalid url and does not save it', () async {
    final repository = _FakeApiUrlRepository();
    final cubit = build(repository)..urlChanged('ggggg');

    await cubit.submit();

    expect(cubit.state, const HomeInvalidUrl('ggggg'));
    expect(repository.url, isNull);
  });

  test('clears the error when the url is edited', () async {
    final cubit = build(_FakeApiUrlRepository())..urlChanged('ggggg');
    await cubit.submit();

    cubit.urlChanged(validUrl);

    expect(cubit.state, const HomeInitial(validUrl));
  });

  test('saves a trimmed valid url', () async {
    final repository = _FakeApiUrlRepository();
    final cubit = build(repository)..urlChanged('  $validUrl ');
    final states = expectLater(
      cubit.stream,
      emitsInOrder(const [HomeSaving(validUrl), HomeSaved(validUrl)]),
    );

    await cubit.submit();

    await states;
    expect(repository.url, validUrl);
  });

  test('saves the url once when Start is pressed twice', () async {
    final repository = _FakeApiUrlRepository(validUrl);
    final cubit = build(repository);

    await Future.wait([cubit.submit(), cubit.submit()]);

    expect(repository.saveCount, 1);
  });

  test('can be submitted again after a successful save', () async {
    final cubit = build(_FakeApiUrlRepository(validUrl));
    await cubit.submit();
    final states = expectLater(
      cubit.stream,
      emitsInOrder(const [HomeSaving(validUrl), HomeSaved(validUrl)]),
    );

    await cubit.submit();

    await states;
  });
}
