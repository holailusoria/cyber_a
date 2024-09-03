part of 'analyzator_bloc.dart';

@immutable
sealed class AnalyzatorEvent extends Equatable {}

final class AnalyzatorDataInitializationEvent extends AnalyzatorEvent {
  @override
  List<Object?> get props => [];
}

final class AnalyzatorStartAnalyzingEvent extends AnalyzatorEvent {
  AnalyzatorStartAnalyzingEvent(this.teamNameFirst, this.teamNameSecond);

  final String teamNameFirst;
  final String teamNameSecond;

  @override
  List<Object?> get props => [teamNameFirst, teamNameSecond];
}
