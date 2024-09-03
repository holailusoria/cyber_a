part of 'change_language_bloc.dart';

@immutable
sealed class ChangeLanguageState extends Equatable{}

final class ChangeLanguageInitialState extends ChangeLanguageState {
  @override
  List<Object?> get props => [];
}

final class ChangeLanguageAppearedState extends ChangeLanguageState {
  ChangeLanguageAppearedState(this.language);

  final Locale language;

  @override
  List<Object?> get props => [language];
}
