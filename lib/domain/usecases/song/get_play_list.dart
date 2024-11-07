import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/core/error/failure.dart';

class GetPlayListUseCase implements UseCase<Either<Failure, List<SongEntity>>, void> {
  final SongsRepository songsRepository;

  GetPlayListUseCase(this.songsRepository);

  @override
  Future<Either<Failure, List<SongEntity>>> call({void params}) async {
    return await songsRepository.getPlayList(); 
  }
}
