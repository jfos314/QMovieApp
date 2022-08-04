part of 'movies_cubit.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

class MovieListLoadingNextPage extends MovieListState {
  final MovieList movieList;
  const MovieListLoadingNextPage(this.movieList);

  @override
  List<Object> get props => [movieList];
}

class MovieListLoaded extends MovieListState {
  final MovieList movieList;
  const MovieListLoaded(this.movieList);

  @override
  List<Object> get props => [movieList];
}

class MovieListLoadedRemoteFailed extends MovieListState {
  final MovieList movieList;
  const MovieListLoadedRemoteFailed(this.movieList);

  @override
  List<Object> get props => [movieList];
}

class MovieListError extends MovieListState {
  final String error;
  const MovieListError(this.error);

  @override
  List<Object> get props => [error];
}
