import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_news_songs.dart';
import 'package:spotify/presentation/home/bloc/news_songs_state.dart';

class NewsSongsCubit extends Cubit<NewsSongsState> {
  final GetNewsSongsUseCase getNewsSongsUseCase;

  NewsSongsCubit(this.getNewsSongsUseCase) : super(NewsSongsLoading());

  Future<void> getNewsSongs() async {
    emit(NewsSongsLoading()); 
    var returnedSongs = await getNewsSongsUseCase.call();
    returnedSongs.fold(
      (failure) {
        emit(NewsSongsLoadFailure());
      },
      (songs) {
        emit(NewsSongsLoaded(songs: songs));
      },
    );
  }
}
