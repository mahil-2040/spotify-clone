import 'package:dartz/dartz.dart';
import 'package:spotify/domain/repository/song/song.dart';

class GetNewsSongsUseCase {
  final SongsRepository songsRepository;

  GetNewsSongsUseCase(this.songsRepository);

  Future<Either> call() async {
    return await songsRepository.getNewsSongs(); // Use the instance to call the method
  }
}
