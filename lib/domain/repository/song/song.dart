import 'package:dartz/dartz.dart';
import 'package:spotify/core/error/failure.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class SongsRepository{

  Future<Either<Failure, List<SongEntity>>> getNewsSongs();
  Future<Either<Failure, List<SongEntity>>> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
}