import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/movie.dart';

class NavigationCubit extends Cubit<Movie?> {
  NavigationCubit() : super(null);

  void showMovieDetails(Movie movie) => emit(movie);
  void popToMovieList() => emit(null);
}
