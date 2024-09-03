part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable{}

class LoginTappedEvent extends LoginEvent{
  final String username;
  final String password;
  final bool stayLoggedIn;

  LoginTappedEvent(this.username, this.password, this.stayLoggedIn);

  @override
  List<Object?> get props => [username, password, stayLoggedIn];
}

class LoginCheckInitialEvent extends LoginEvent{
  @override
  List<Object?> get props => [];
}