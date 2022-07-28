// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieListAdapter extends TypeAdapter<MovieList> {
  @override
  final int typeId = 1;

  @override
  MovieList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieList(
      page: fields[0] as int,
      movieList: (fields[1] as List).cast<Movie>(),
      totalPages: fields[2] as int,
      totalResults: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MovieList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.movieList)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.totalResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
