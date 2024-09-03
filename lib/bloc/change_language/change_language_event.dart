part of 'change_language_bloc.dart';

@immutable
sealed class ChangeLanguageEvent extends Equatable{
  const ChangeLanguageEvent();
}

class ChangeLanguageTappedEvent extends ChangeLanguageEvent {
  const ChangeLanguageTappedEvent(this.lang);

  final String lang;

  @override
  List<Object?> get props => [lang];
}
