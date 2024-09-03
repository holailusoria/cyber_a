import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginCheckInitialEvent>((event, emit) async {
      try {
        var currentUserToken = await Backendless.userService.getUserToken();

        if(currentUserToken != null) {
          var isValid = await Backendless.userService.isValidLogin();

          if(isValid) {
            var currentUser = await Backendless.userService.getCurrentUser(true);

            if(currentUser != null) {
              emit(LoginCompletedState(currentUser));
            }
          }
        }
      } catch(ex) {
        print('current user doesn\'t exists. Need do nothing');
      }
    });
    on<LoginTappedEvent>((event, emit) async {
      try {
        emit(LoginCompletingState());
        var user = await Backendless.userService.login(
            event.username, event.password, stayLoggedIn: event.stayLoggedIn);

        emit(LoginCompletedState(user!));
      } catch(ex) {
        emit(LoginFailureState(ex));
      }
    });
  }
}
