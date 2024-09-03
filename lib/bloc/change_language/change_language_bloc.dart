import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'change_language_event.dart';
part 'change_language_state.dart';

class ChangeLanguageBloc extends Bloc<ChangeLanguageEvent, ChangeLanguageState> {
  ChangeLanguageBloc() : super(ChangeLanguageInitialState()) {
    on<ChangeLanguageTappedEvent>((event, emit) {
      Locale locale = Locale(event.lang);
      emit(ChangeLanguageAppearedState(locale));
    });
  }
}
