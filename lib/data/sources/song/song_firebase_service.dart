import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class SongFirebaseService {
  Future<Either<String, List<SongEntity>>> getNewsSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either<String, List<SongEntity>>> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .limit(4)
          .get();

      for (var element in data.docs) {
        try {
          var songModel = SongModel.fromJson(element.data());
          songs.add(songModel.toEntity());
        } catch (e) {
          return const Left('Data format error: unable to convert song.');
        }
      }

      return Right(songs);
    } catch (e) {
      return const Left('An error occurred while fetching songs. Please try again later.');
    }
  }
}
