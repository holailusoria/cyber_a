import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpTappedEvent>((event, emit) async {
      emit(SignUpTappedState());

      BackendlessUser userToRegister = BackendlessUser()
        ..email = event.email
        ..password = event.password
        ..setProperty('name', event.username);

      try {
        await Backendless.userService.register(userToRegister);
        emit(SignUpCompletedState());
      } catch (ex) {
        emit(SignUpFailureState());
      }
    });

    on<SignUpClosedAlertEvent>((event, emit) => emit(SignUpClosedAlertState()));
  }
}
