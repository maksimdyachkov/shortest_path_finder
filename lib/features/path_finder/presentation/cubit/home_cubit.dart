import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/url_validator.dart';
import '../../domain/repositories/api_url_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository, this._validator)
    : super(HomeInitial(_repository.getUrl() ?? ''));

  final ApiUrlRepository _repository;
  final UrlValidator _validator;

  void urlChanged(String url) {
    emit(HomeInitial(url));
  }

  /// Saves the entered url if it is valid.
  /// Does nothing while a previous saving is still in progress.
  Future<void> submit() async {
    if (state is HomeSaving) return;

    final url = state.url.trim();

    if (!_validator.isValid(url)) {
      emit(HomeInvalidUrl(state.url));
      return;
    }

    emit(HomeSaving(url));
    await _repository.saveUrl(url);
    emit(HomeSaved(url));
  }
}
