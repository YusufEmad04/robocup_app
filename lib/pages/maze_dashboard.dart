import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robocup_final1/dialogs/maze_dashboard_dialogs.dart';
import 'dart:html' as html;
import '../blocs/maze/maze_bloc.dart';
import '../models/MazeRound.dart';

class MazeDashboard extends StatelessWidget {
  const MazeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MazeBloc(),
      child: BlocBuilder<MazeBloc, MazeState>(
        builder: (context, state) {
          final bloc = context.read<MazeBloc>();
          if (state is MazeDashboardValues){
            return Scaffold(
              appBar: AppBar(
                title: const Text('Maze Dashboard'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(state.items[index].team.name.toString()),
                                subtitle: Text("score: ${state.items[index].score}"),
                              ),
                              // const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // add a new scoreboard
                              // final newScoreBoard = ScoreBoard(owner: user.id);
                              final result = await showMazeRoundInputDialog(context, state.teams);
                              if(result != null){

                                var (team, roundNumber, score) = result;

                                if(team != null){
                                  print(team);
                                  bloc.add(CreateMazeRound(round: MazeRound(score: score, number: roundNumber, team: team)));
                                }

                              }

                            },
                            child: const Text('Add ScoreBoard'),
                          ),
                          // a button that downloads a dummy file (running on flutter web)
                          ElevatedButton(
                            onPressed: () async {
                              // check if web or mobile
                              if (kIsWeb){
                                final blob = html.Blob(['Hello, world!'], 'text/plain', 'native');
                                final url = html.Url.createObjectUrlFromBlob(blob);

                                final anchor = html.document.createElement('a') as html.AnchorElement
                                  ..href = url
                                  ..style.display = 'none'
                                  ..download = 'hello_world.txt';
                                html.document.body!.children.add(anchor);

                                // download
                                anchor.click();

                                // cleanup
                                html.document.body!.children.remove(anchor);
                                html.Url.revokeObjectUrl(url);
                              } else {
                                // mobile
                                // start download in mobile
                              }
                            },
                            child: const Text('Download File'),
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ),
            );
          } else if (state is MazeLoading){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          }
        }
      )
    );
  }
}
