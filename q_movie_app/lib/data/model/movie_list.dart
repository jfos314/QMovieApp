import 'package:hive_flutter/hive_flutter.dart';
import 'movie.dart';

part 'movie_list.g.dart';

@HiveType(typeId: 1)
class MovieList {
  @HiveField(0)
  int page;
  @HiveField(1)
  List<Movie> movieList;
  @HiveField(2)
  int totalPages;
  @HiveField(3)
  int totalResults;
  @HiveField(4)
  List<Movie>? favouriteList;

  MovieList({
    required this.page,
    required this.movieList,
    required this.totalPages,
    required this.totalResults,
    this.favouriteList,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) => MovieList(
        page: json['page'] as int,
        movieList:
            json['results'].map<Movie>((j) => Movie.fromJson(j)).toList(),
        totalPages: json['total_pages'] as int,
        totalResults: json['total_results'] as int,
      );
}
