import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide Emitter;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:robocup_final1/models/MazeTeam.dart';

import '../../models/MazeRound.dart';

part 'maze_event.dart';
part 'maze_state.dart';

class MazeBloc extends Bloc<MazeEvent, MazeState> {

  final _mazeRounds = <MazeRound>[];
  final _mazeTeams = <MazeTeam>[];

  MazeBloc() : super(MazeLoading()) {

    _initializeBloc();

    on<CreateMazeRound>(_handleCreateMazeRound);
    on<MazeDashboardInitialized>(_handleMazeDashboardInitialized);
    on<MazeDashboardInitializeFail>(_handleMazeDashboardInitializeFail);
  }

  void _initializeBloc() async {
    try {
      final mazeRoundsRequest = ModelQueries.list(MazeRound.classType);
      final mazeTeamsRequest = ModelQueries.list(MazeTeam.classType);

      final mazeRoundsResponse = await Amplify.API.query(request: mazeRoundsRequest).response;
      final mazeTeamsResponse = await Amplify.API.query(request: mazeTeamsRequest).response;

      final mazeRoundsItems = mazeRoundsResponse.data?.items;
      final mazeTeamsItems = mazeTeamsResponse.data?.items;

      if (mazeRoundsItems != null){
        for(var item in mazeRoundsItems){
          _mazeRounds.add(item!);
        }
      }

      if (mazeTeamsItems != null){
        for(var item in mazeTeamsItems){
          _mazeTeams.add(item!);
        }
      }

      // sort them by createdAt
      _mazeRounds.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      _mazeTeams.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      add(const MazeDashboardInitialized());
    } catch (e) {
      add(const MazeDashboardInitializeFail());
    }
  }

  void _handleCreateMazeRound(CreateMazeRound event, Emitter<MazeState> emit) async{
    _mazeRounds.add(event.round);
    emit(MazeDashboardValues(items: [..._mazeRounds], teams: [..._mazeTeams]));

    final model = event.round;
    final request = ModelMutations.create(model, authorizationMode: APIAuthorizationType.userPools);

    final response = await Amplify.API.mutate(request: request).response;
    final round = response.data;

    if (round == null){
      _mazeRounds.removeWhere((element) {
        if (element.id == model.id){
          print("Removing ${element}");
        }
        return element.id == model.id;
      });
      emit(MazeDashboardValues(items: [..._mazeRounds], teams: [..._mazeTeams]));
    }
  }

  void _handleMazeDashboardInitialized(MazeDashboardInitialized event, Emitter<MazeState> emit) {
    emit(MazeDashboardValues(items: [..._mazeRounds], teams: [..._mazeTeams]));
  }

  void _handleMazeDashboardInitializeFail(MazeDashboardInitializeFail event, Emitter<MazeState> emit) {
    emit(const MazeDashboardError());
  }

}
