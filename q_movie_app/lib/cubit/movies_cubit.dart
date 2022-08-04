import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/movie.dart';
import '../data/model/movie_list.dart';
import '../data/movie_repository.dart';

part 'movies_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final MovieRepository _movieRepository;
  int _page = 0;
  MovieList? movieList;

  MovieListCubit(this._movieRepository) : super(const MovieListLoading());

  Future<void> getInitialMovieList({required String apiKey}) async {
    emit(const MovieListLoading());

    _page++;

    MovieList? currPageList =
        await _movieRepository.getMovieList(page: _page, apiKey: apiKey);

    if (currPageList == null && movieList == null) {
      emit(const MovieListError('failed to load'));
    } else if (currPageList != null && movieList == null) {
      _page = currPageList.movieList.length % 20 + 1;
      movieList = MovieList(
        page: _page,
        movieList: currPageList.movieList.toList(),
        totalPages: currPageList.totalPages,
        totalResults: currPageList.totalResults,
      );
      _movieRepository.saveLocally(movieList!);
      emit(MovieListLoaded(movieList!));
    } else if (currPageList != null && movieList != null) {
      movieList!.movieList.addAll(currPageList.movieList);
      emit(MovieListLoaded(movieList!));
    }
  }

  Future<void> getNextPageMovieList({required String apiKey}) async {
    if (movieList == null) {
      throw Error();
    } else {
      emit(MovieListLoadingNextPage(movieList!));
    }

    _page++;
    MovieList? currPageList =
        await _movieRepository.getMovieList(page: _page, apiKey: apiKey);

    if (currPageList == null && movieList != null) {
      _page--;
      emit(MovieListLoadedRemoteFailed(movieList!));
    } else if (currPageList != null && movieList == null) {
      movieList = MovieList(
        page: currPageList.page,
        movieList: currPageList.movieList.toList(),
        totalPages: currPageList.totalPages,
        totalResults: currPageList.totalResults,
      );
      emit(MovieListLoaded(movieList!));
    } else if (currPageList != null && movieList != null) {
      movieList!.movieList.addAll(currPageList.movieList);
      emit(MovieListLoaded(movieList!));
    }
  }

  Future<void> toggleFavourite(Movie fav) async {
    movieList?.favouriteList ??= [];

    if (isFavourite(fav)) {
      movieList?.favouriteList?.remove(fav);
    } else {
      movieList?.favouriteList?.add(fav);
    }
    _movieRepository.saveLocally(movieList!);
  }

  bool isFavourite(Movie fav) {
    if (movieList?.favouriteList == null) return false;
    return movieList?.favouriteList?.contains(fav) ?? false;
  }
}
