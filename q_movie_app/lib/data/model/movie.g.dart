// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 2;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      voteAverage: fields[2] as double,
      overview: fields[3] as String,
      genreIds: (fields[4] as List).cast<int>(),
      genreNames: (fields[5] as List).cast<String>(),
      backdropPath: fields[6] as String,
      favourite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.voteAverage)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.genreIds)
      ..writeByte(5)
      ..write(obj.genreNames)
      ..writeByte(6)
      ..write(obj.backdropPath)
      ..writeByte(7)
      ..write(obj.favourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
