import 'package:hive_flutter/hive_flutter.dart';

part 'movie.g.dart';

@HiveType(typeId: 2)
class Movie {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double voteAverage;
  @HiveField(3)
  String overview;
  @HiveField(4)
  List<int> genreIds;
  @HiveField(5)
  List<String> genreNames;
  @HiveField(6)
  final String backdropPath;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.genreIds,
    required this.genreNames,
    required this.backdropPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: json['title'] as String,
        voteAverage: double.tryParse(json['vote_average'].toString()) as double,
        overview: json['overview'] as String,
        genreIds: List<int>.from(json['genre_ids']),
        genreNames: [],
        backdropPath: json['backdrop_path'] as String,
      );
}
