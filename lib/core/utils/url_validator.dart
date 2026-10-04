class UrlValidator {
  const UrlValidator();

  static const _allowedSchemes = {'http', 'https'};
  static final _whitespace = RegExp(r'\s');

  bool isValid(String value) {
    final url = value.trim();
    if (url.contains(_whitespace)) return false;

    final uri = Uri.tryParse(url);
    return uri != null &&
        _allowedSchemes.contains(uri.scheme) &&
        uri.host.isNotEmpty;
  }
}
