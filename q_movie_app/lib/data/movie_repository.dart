import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/genre.dart';
import 'model/movie_list.dart';
import 'model/genre_list.dart';
import '../helpers/my_const.dart' as consts;

class MovieRepository {
  final Dio _dio = Dio();
  final Dio _dioGenre = Dio();

  late Box<MovieList> _movieListBox;

  GenreList? _genreList;

  MovieRepository() {
    _movieListBox = Hive.box<MovieList>('movielist');
  }

  Future<MovieList?> getMovieList(
      {required int page, required String apiKey}) async {
    try {
      _genreList ??= await getGenreList();
      _dio.options.headers["authorization"] = "Bearer ${consts.bearerToken}";

      Response movieListData = await _dio
          .get('${consts.baseMovieUrl}/popular?language=en_US&page=$page');

      final tmp = MovieList.fromJson(movieListData.data);
      tmp.favouriteList ??= [];

      if (page == 1 &&
          _movieListBox.values.isNotEmpty &&
          _movieListBox.values.first.favouriteList != null) {
        tmp.favouriteList!
            .addAll(_movieListBox.values.first.favouriteList!.toList());
      }

      if (_genreList != null) updateGenres(tmp);

      return tmp;
    } on DioError {
      if (_movieListBox.isNotEmpty) {
        if (page == 1) {
          return _movieListBox.getAt(0)!;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  Future<GenreList?> getGenreList() async {
    try {
      _dioGenre.options.headers["authorization"] =
          "Bearer ${consts.bearerToken}";

      Response genreListData = await _dioGenre.get(consts.baseGenreUrl);

      return GenreList.fromJson(genreListData.data);
    } on DioError {
      return null;
    }
  }

  void updateGenres(MovieList movieList) {
    if (_genreList == null) return;
    for (var movie in movieList.movieList) {
      for (int gIndex in movie.genreIds) {
        for (Genre g in _genreList!.genreList) {
          if (gIndex == g.id) {
            movie.genreNames.add(g.name);
          }
        }
      }
    }
  }

  //implement update single page
  void saveLocally(MovieList movieList) {
    _movieListBox.clear();
    _movieListBox.add(movieList);
    _movieListBox.flush();
  }
}
