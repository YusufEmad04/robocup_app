part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}


class AppLoading extends AppState {
  @override
  List<Object> get props => [];
}

class AppLoggedIn extends AppState {

  final AuthUser user;
  final String userType;

  const AppLoggedIn({required this.user, required this.userType});

  @override
  List<Object> get props => [];
}


class AppError extends AppState {

  final String errorMessage;

  const AppError({required this.errorMessage});

  @override
  List<Object> get props => [];
}