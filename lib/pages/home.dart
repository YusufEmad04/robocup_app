import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robocup_final1/pages/maze_dashboard.dart';

import '../blocs/app/app_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          print("state is $state");
          if (state is AppLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AppLoggedIn) {

            if (state.userType == "MazeJudges"){
              return const MazeDashboard();
            }

            return Scaffold(
              body: Center(
                child: Center(
                  child: Text(state.userType)
                ),
              ),
            );
          } else if (state is AppError) {
            return Scaffold(
              body: Center(
                child: Center(
                    child: Text("${state.errorMessage}")
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text('Error'),
            ),
          );
        },
      )
    );
  }
}
