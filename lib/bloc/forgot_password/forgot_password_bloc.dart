import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRestoring>((event, emit) async {
      try {
        await Backendless.userService.restorePassword(event.identity);
      } catch(ex) {
        emit(ForgotPasswordFailure());
      }
    });
  }
}
