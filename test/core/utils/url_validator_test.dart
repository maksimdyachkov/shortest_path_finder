import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_finder/core/utils/url_validator.dart';

void main() {
  const validator = UrlValidator();

  test('accepts http and https urls, including query parameters', () {
    expect(validator.isValid('https://flutter.webspark.dev/flutter/api'), true);
    expect(validator.isValid('http://10.0.2.2:8080/api?a=1&b=2'), true);
    expect(validator.isValid('  https://example.com/api?key=value  '), true);
  });

  test('rejects malformed urls', () {
    expect(validator.isValid(''), false);
    expect(validator.isValid('ggggg'), false);
    expect(validator.isValid('example.com/api'), false);
    expect(validator.isValid('ftp://example.com'), false);
    expect(validator.isValid('https://'), false);
    expect(validator.isValid('https://exa mple.com'), false);
  });
}
