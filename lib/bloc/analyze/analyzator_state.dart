part of 'analyzator_bloc.dart';

@immutable
sealed class AnalyzatorState extends Equatable {}

final class AnalyzatorInitialState extends AnalyzatorState {
  @override
  List<Object?> get props => [];
}

final class AnalyzatorDataInitializationState extends AnalyzatorState {
  @override
  List<Object?> get props => [];
}

final class AnalyzatorInitializedState extends AnalyzatorState {
  AnalyzatorInitializedState(this.teamNames);

  final List<String> teamNames;

  @override
  List<Object?> get props => [teamNames];
}

final class AnalyzatorStartAnalyzingState extends AnalyzatorState {
  @override
  List<Object?> get props => [];

}
