part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitialState extends SignUpState {}

final class SignUpTappedState extends SignUpState {}

final class SignUpCompletedState extends SignUpState{}

final class SignUpClosedAlertState extends SignUpState{}

final class SignUpFailureState extends SignUpState{}
