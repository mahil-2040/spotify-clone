import 'package:dartz/dartz.dart';
import 'package:spotify/core/error/failure.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';

class GetNewsSongsUseCase {
  final SongsRepository songsRepository;

  GetNewsSongsUseCase(this.songsRepository);

  Future<Either<Failure, List<SongEntity>>> call() async {
    return await songsRepository.getNewsSongs();
  }
}
