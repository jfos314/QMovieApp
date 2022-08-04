import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'movie.g.dart';

@HiveType(typeId: 2)
class Movie extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double voteAverage;
  @HiveField(3)
  final String overview;
  @HiveField(4)
  final List<int> genreIds;
  @HiveField(5)
  List<String> genreNames;
  @HiveField(6)
  final String backdropPath;
  @HiveField(7)
  bool favourite;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.genreIds,
    required this.genreNames,
    required this.backdropPath,
    required this.favourite,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: json['title'] as String,
        voteAverage: double.tryParse(json['vote_average'].toString()) as double,
        overview: json['overview'] as String,
        genreIds: List<int>.from(json['genre_ids']),
        genreNames: [],
        backdropPath: json['backdrop_path'] as String,
        favourite: false,
      );

  @override
  List<Object> get props => [
        id,
        title,
        voteAverage,
        overview,
        genreIds,
        genreNames,
        backdropPath,
        favourite
      ];
}
