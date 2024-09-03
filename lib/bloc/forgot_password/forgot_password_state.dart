part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordRequest extends ForgotPasswordState {}

final class ForgotPasswordFailure extends ForgotPasswordState {
}