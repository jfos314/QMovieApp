import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/movie_details_page.dart';
import 'pages/movie_list_page.dart';
import '../cubit/navigation_cubit.dart';
import '../data/model/movie.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, Movie?>(
      builder: (context, movie) {
        return Navigator(
          pages: [
            const MaterialPage(child: MovieListPage()),
            if (movie != null)
              MaterialPage(child: MovieDetailsPage(movie: movie))
          ],
          onPopPage: (route, result) {
            BlocProvider.of<NavigationCubit>(context).popToMovieList();
            return route.didPop(result);
          },
        );
      },
    );
  }
}
