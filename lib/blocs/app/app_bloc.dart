import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide Emitter;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppLoading()) {

    checkForLoginStatus();

    on<UserSignedIn>(_handleSignedIn);
    on<SignInFailed>(_handleSignInFailed);
  }

  Future<void> checkForLoginStatus() async {
    try {
      final session = await Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey).fetchAuthSession();

      if (session.isSignedIn){
        print("signed in");

        final user = await Amplify.Auth.getCurrentUser();
        String userType = "";
        if (session.userPoolTokensResult.value.idToken.groups.isNotEmpty){
          userType = session.userPoolTokensResult.value.idToken.groups[0];
        }

        add(UserSignedIn(user: user, userType: userType));

      } else {
        print("errorgfgdfgsdfgsdf");
        add(const SignInFailed(errorMessage: "user not signed in"));
      }
    } catch (e) {
      print("failed");
      add(SignInFailed(errorMessage: e.toString()));
    }
  }

  void _handleSignInFailed(SignInFailed event, Emitter<AppState> emit){
    emit(AppError(errorMessage: event.errorMessage));
  }

  void _handleSignedIn(UserSignedIn event, Emitter<AppState> emit) async {
    emit(AppLoggedIn(user: event.user, userType: event.userType));
  }

}
