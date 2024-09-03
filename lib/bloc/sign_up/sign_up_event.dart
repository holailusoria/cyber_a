part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {
}

final class SignUpTappedEvent extends SignUpEvent {
  SignUpTappedEvent(this.email, this.username, this.password);

  final String email;
  final String username;
  final String password;
}

final class SignUpClosedAlertEvent extends SignUpEvent {}
