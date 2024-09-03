part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

class ForgotPasswordRestoring extends ForgotPasswordEvent {
  ForgotPasswordRestoring(this.identity);

  final String identity;
}
