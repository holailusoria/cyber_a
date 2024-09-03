import 'package:cyber_a/constants/teams/team_names.dart';

extension TeamNamesValidator on String {
  bool isValidTeamName() {
    return teamNames.contains(this);
  }
}