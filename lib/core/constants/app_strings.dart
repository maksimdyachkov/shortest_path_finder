abstract final class AppStrings {
  static const appTitle = 'Shortest Path Finder';

  static const homeTitle = 'Home screen';
  static const homeDescription = 'Set valid API base URL in order to continue';
  static const homeStartButton = 'Start counting process';
  static const homeInvalidUrl = 'Invalid URL';

  static const processTitle = 'Process screen';
  static const processLoading = 'Loading tasks from server';
  static const processCalculating = 'Calculations are in progress';
  static const processFinished =
      'All calculations has finished, you can send your results to server';
  static const processSendButton = 'Send results to server';

  static const resultListTitle = 'Result list screen';

  static const errorNoConnection =
      'Unable to reach the server. Check your internet connection';
  static const errorUnexpected =
      'Unexpected server response. '
      'Make sure the API URL is correct or try again later';
  static const errorMissingUrl = 'The API URL is not set';

  static String percent(int value) => '$value%';
}
