part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {}

final class LoginInitialState extends LoginState {
  LoginInitialState() {
    Backendless.userService.getCurrentUser(false).then((user){
      initialUser = user;
    });
  }

  late BackendlessUser? initialUser;

  @override
  List<Object?> get props => [initialUser];
}

final class LoginCompletingState extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginCompletedState extends LoginState {
  LoginCompletedState(this.user);

  final BackendlessUser user;

  @override
  List<Object?> get props => [user];
}

final class LoginFailureState extends LoginState {
  LoginFailureState(this.exception);

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}
