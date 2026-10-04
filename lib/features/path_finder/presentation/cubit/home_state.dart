import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState(this.url);

  final String url;

  @override
  List<Object?> get props => [url];
}

final class HomeInitial extends HomeState {
  const HomeInitial(super.url);
}

final class HomeInvalidUrl extends HomeState {
  const HomeInvalidUrl(super.url);
}

final class HomeSaving extends HomeState {
  const HomeSaving(super.url);
}

final class HomeSaved extends HomeState {
  const HomeSaved(super.url);
}
