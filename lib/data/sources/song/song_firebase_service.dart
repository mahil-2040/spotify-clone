import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/core/error/failure.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either<Failure, List<SongEntity>>> getNewsSongs();
  Future<Either<Failure, List<SongEntity>>> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either<Failure, List<SongEntity>>> getNewsSongs() async {
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
          Either<Failure, bool> isFavorite = await sl<IsFavoriteSongUseCase>().call(
            params: element.reference.id,
          );
          songModel.isFavorite = isFavorite.fold((_) => false, (fav) => fav);
          songModel.songId = element.reference.id;
          songs.add(songModel.toEntity());
        } catch (e) {
          return Left(DataFormatFailure("Data format error: unable to convert song."));
        }
      }
      return Right(songs);
    } catch (e) {
      return Left(ServerFailure("An error occurred while fetching songs. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, List<SongEntity>>> getPlayList() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      for (var element in data.docs) {
        try {
          var songModel = SongModel.fromJson(element.data());
          Either<Failure, bool> isFavorite = await sl<IsFavoriteSongUseCase>().call(
            params: element.reference.id,
          );
          songModel.isFavorite = isFavorite.fold((_) => false, (fav) => fav);
          songModel.songId = element.reference.id;
          songs.add(songModel.toEntity());
        } catch (e) {
          return Left(DataFormatFailure("Data format error: unable to convert song."));
        }
      }
      return Right(songs);
    } catch (e) {
      return Left(ServerFailure("An error occurred while fetching playlist. Please try again later."));
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      late bool isFavorite;
      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });
        isFavorite = true;
      }
      return Right(isFavorite);
    } catch (e) {
      return const Left('An error has occurred');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      } 
    } catch (e) {
      return false;
    }
  }
}
