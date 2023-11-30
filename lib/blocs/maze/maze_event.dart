part of 'maze_bloc.dart';

abstract class MazeEvent extends Equatable {
  const MazeEvent();
}

class CreateMazeRound extends MazeEvent {

  final MazeRound round;
  const CreateMazeRound({required this.round});

  @override
  List<Object> get props => [round];
}

class MazeDashboardInitialized extends MazeEvent {
  const MazeDashboardInitialized();

  @override
  List<Object> get props => [];
}

class MazeDashboardInitializeFail extends MazeEvent {
  const MazeDashboardInitializeFail();

  @override
  List<Object> get props => [];
}