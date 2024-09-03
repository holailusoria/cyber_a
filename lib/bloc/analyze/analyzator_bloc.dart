import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'analyzator_event.dart';
part 'analyzator_state.dart';

class AnalyzatorBloc extends Bloc<AnalyzatorEvent, AnalyzatorState> {
  AnalyzatorBloc() : super(AnalyzatorInitialState()) {
    on<AnalyzatorDataInitializationEvent>((event, emit) async {
      emit(AnalyzatorDataInitializationState());
      String stringFileCSV = await rootBundle.loadString('assets/team_info/team_names.csv');

      List<String> listNames = (const CsvToListConverter().convert(stringFileCSV,)[0][0] as String).split('\n');
      listNames.remove('name');

      emit(AnalyzatorInitializedState(listNames));
    });

    on<AnalyzatorStartAnalyzingEvent>((event, emit) {
      emit(AnalyzatorStartAnalyzingState());


    });
  }
}
