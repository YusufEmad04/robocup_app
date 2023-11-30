part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class UserSignedIn extends AppEvent {

  final AuthUser user;
  final String userType;
  const UserSignedIn({required this.user, required this.userType});

  @override
  List<Object> get props => [];
}

class SignInFailed extends AppEvent {

  final String errorMessage;
  const SignInFailed({required this.errorMessage});

  @override
  List<Object> get props => [];
}