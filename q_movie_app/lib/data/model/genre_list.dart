import 'genre.dart';

class GenreList {
  List<Genre> genreList;

  GenreList({
    required this.genreList,
  });

  factory GenreList.fromJson(Map<String, dynamic> json) => GenreList(
        genreList: json['genres'].map<Genre>((j) => Genre.fromJson(j)).toList(),
      );
}
