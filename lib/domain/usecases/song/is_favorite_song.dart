import 'package:dartz/dartz.dart';
import 'package:spotify/core/error/failure.dart';
import 'package:spotify/core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/song/song.dart';

class IsFavoriteSongUseCase implements UseCase<bool, String> {
  @override
  Future<Either<Failure, bool>> call({String? params}) async {
    try {
      final isFavorite = await sl<SongsRepository>().isFavoriteSong(params!);
      return Right(isFavorite); 
    } catch (error) {
      return Left(ServerFailure('error'));
    }
  }
}


