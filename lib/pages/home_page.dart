import 'dart:io';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cyber_a/constants/constants.dart';
import 'package:cyber_a/utils/validators/team_names_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:csv/csv.dart';
import '../bloc/analyze/analyzator_bloc.dart';
import '../constants/teams/team_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final AnalyzatorBloc analyzatorBloc = AnalyzatorBloc();
  final firstTeamNameController = TextEditingController();
  final secondTeamNameController = TextEditingController();
  List<String> teamsSuggestionsFirst = [];
  List<String> teamsSuggestionsSecond = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        leading: Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: () => {},
            style: ButtonStyle(
              padding: WidgetStateProperty.resolveWith((states) =>
              EdgeInsets.zero),
              foregroundColor: Theme
                  .of(context)
                  .elevatedButtonTheme
                  .style!
                  .backgroundColor,
              backgroundColor: WidgetStateProperty.resolveWith((states) =>
              Theme
                  .of(context)
                  .appBarTheme
                  .backgroundColor),
              elevation: WidgetStateProperty.resolveWith((states) => 0.0),
              shape: WidgetStateProperty.resolveWith((states) =>
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              ),
            ),
            child: const Icon(Icons.menu_sharp),
          ),
        ),
      ),
      body: BlocBuilder<AnalyzatorBloc, AnalyzatorState>(
        bloc: analyzatorBloc,
        builder: (context, state) {
          if (state is AnalyzatorInitialState) {
            if (teamNames.isEmpty) {
              analyzatorBloc.add(AnalyzatorDataInitializationEvent());
            }
          }

          if (state is AnalyzatorInitializedState) {
            teamNames = state.teamNames;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.chooseTwoTeams,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      height: 512,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: _searchBarFirst(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: _searchBarSecond(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: _analyzeButton(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.dataLoading),
                  const CircularProgressIndicator(),
                ],
              ));
        },
      ),
    );
  }

  Widget _searchBarFirst() {
    return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextFormField(
                controller: firstTeamNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .teamNameTextFieldHint,
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                validator: (value) =>
                value!.isValidTeamName()
                    ? null
                    : AppLocalizations.of(context)!.unknownTeamValidatorText,
                onChanged: (query) {
                  final List<String> suggestions = teamsFamous.where((team) {
                    return team.contains(query);
                  }).toList();

                  setState(() {
                    teamsSuggestionsFirst = suggestions.take(4).toList();
                  });
                },
                onFieldSubmitted: (str) =>
                    setState(() {
                      teamsSuggestionsFirst = [];
                    }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ListView.separated(
                    separatorBuilder: (context, i) =>
                    const SizedBox(height: 2.0,),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: teamsSuggestionsFirst.length > 4
                        ? 4
                        : teamsSuggestionsFirst.length,
                    itemBuilder: (context, index) {
                      final team = teamsSuggestionsFirst[index];

                      return ListTile(
                        title: Text(team),
                        onTap: () {
                          firstTeamNameController.text = team;

                          setState(() {
                            teamsSuggestionsFirst = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _searchBarSecond() {
    return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextFormField(
                controller: secondTeamNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .teamNameTextFieldHint,
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),
                validator: (value) =>
                value!.isValidTeamName()
                    ? null
                    : AppLocalizations.of(context)!.unknownTeamValidatorText,
                onChanged: (query) {
                  final List<String> suggestions = teamsFamous.where((team) {
                    return team.contains(query);
                  }).toList();

                  setState(() {
                    teamsSuggestionsSecond = suggestions.take(4).toList();
                  });
                },
                onFieldSubmitted: (str) =>
                    setState(() {
                      teamsSuggestionsSecond = [];
                    }),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ListView.separated(
                    separatorBuilder: (context, i) =>
                    const SizedBox(height: 2.0,),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: teamsSuggestionsSecond.length >= 4
                        ? 4
                        : teamsSuggestionsSecond.length,
                    itemBuilder: (context, index) {
                      final team = teamsSuggestionsSecond[index];

                      return ListTile(
                        title: Text(team),
                        onTap: () {
                          secondTeamNameController.text = team;
                          setState(() {
                            teamsSuggestionsSecond = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  void searchTeamSecond(String query) {
    final List<String> suggestions = teamsFamous.where((team) {
      return team.contains(query);
    }).toList();

    setState(() {
      teamsSuggestionsSecond = suggestions.take(4).toList();
    });
  }

  Widget _analyzeButton() {

    return Positioned(
      bottom: 20,
      child: ElevatedButton(
        onPressed: () {
          String firstTeam = firstTeamNameController.text;
          String secondTeam = secondTeamNameController.text;

          if(firstTeam.isEmpty || secondTeam.isEmpty) {
            return;
          }

          if (firstTeam.isValidTeamName() &&
              secondTeam.isValidTeamName()) {
            analyzatorBloc.add(AnalyzatorStartAnalyzingEvent(
                firstTeamNameController.text, secondTeamNameController.text));
          }
        },
        child: Text(AppLocalizations.of(context)!.startAnalyzeButtonText),
      ),
    );
  }
}