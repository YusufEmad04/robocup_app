import 'package:flutter/material.dart';

import '../models/MazeTeam.dart';

Future<(MazeTeam?, int, int)?> showMazeRoundInputDialog(BuildContext context, List<MazeTeam> teams) async {
  final roundNumberController = TextEditingController();
  final scoreController = TextEditingController();
  SelectedTeam selectedTeam;
  if (teams.isEmpty){
    selectedTeam = SelectedTeam(team: null);
  } else {
    selectedTeam = SelectedTeam(team: teams[0]);
  }
  final formKey = GlobalKey<FormState>();

  bool? isConfirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Your Name'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TeamDropdown(teams: teams, team: selectedTeam),
              TextFormField(
                controller: scoreController,
                decoration: const InputDecoration(
                  labelText: 'Score',
                  hintText: 'Enter team score',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Score can't be empty";
                  }
                  if (int.tryParse(value) == null) {
                    return "Score must be a number";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: roundNumberController,
                decoration: const InputDecoration(
                  labelText: 'Round Number',
                  hintText: 'Enter round number',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Score can't be empty";
                  }
                  if (int.tryParse(value) == null) {
                    return "Score must be a number";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );

  if (isConfirmed == true) {
    return (selectedTeam.team, int.parse(roundNumberController.text), int.parse(scoreController.text));
  } else {
    return null;
  }
}

class TeamDropdown extends StatefulWidget {
  final List<MazeTeam?> teams;
  final SelectedTeam team;
  const TeamDropdown({required this.teams, required this.team, super.key});

  @override
  State<TeamDropdown> createState() => _TeamDropdownState();
}

class _TeamDropdownState extends State<TeamDropdown> {
  @override
  Widget build(BuildContext context) {

    if (widget.teams.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return DropdownButton<MazeTeam>(
        value: widget.team.team,
        onChanged: (value) {
          setState(() {
            widget.team.team = value!;
          });
        },
        items: widget.teams.map((e) => DropdownMenuItem<MazeTeam>(
          value: e!,
          child: Text(e.name),
        )).toList(),
      );
    }
  }
}

class SelectedTeam{
  late MazeTeam? team;
  SelectedTeam({required this.team});
}
