import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  bool isPaused = false;

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      emit(SongPlayerLoaded()); // Update position in the UI
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        songDuration = duration;
      }
    });
  }

  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.setUrl(url);
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause(); // Use pause instead of stop to avoid reloading
      isPaused = true;
    } else {
      audioPlayer.play();
      isPaused = false;
    }
    emit(SongPlayerLoaded()); // Emit state to update the UI
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
