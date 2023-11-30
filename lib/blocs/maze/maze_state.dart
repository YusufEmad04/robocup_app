part of 'maze_bloc.dart';

abstract class MazeState extends Equatable {
  const MazeState();
}

class MazeInitial extends MazeState {
  @override
  List<Object> get props => [];
}

class MazeLoading extends MazeState {
  @override
  List<Object> get props => [];
}

class MazeDashboardValues extends MazeState {
  final List<MazeRound> items;
  final List<MazeTeam> teams;
  const MazeDashboardValues({required this.items, required this.teams});

  @override
  List<Object> get props => [items, teams];
}

class MazeDashboardError extends MazeState {

  const MazeDashboardError();
  @override
  List<Object> get props => [];
}