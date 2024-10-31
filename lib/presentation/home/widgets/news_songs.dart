import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/core/configs/Themes/app_color.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_news_songs.dart';
import 'package:spotify/presentation/home/bloc/news_songs_cubit.dart';

import '../../../service_locator.dart';
import '../bloc/news_songs_state.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit(sl<GetNewsSongsUseCase>())..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongsLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (state is NewsSongsLoaded) {
              return _songs(state.songs);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final imageUrl = '${AppURLs.firestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppURLs.mediaAlt}';
        return SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                      onError: (error, stackTrace) =>
                          const Icon(Icons.error), // Error handling icon
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 40,
                      width: 40,
                      transform: Matrix4.translationValues(-10, 10, 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.isDarkMode ? AppColors.darkGrey : const Color(0xffE6E6E6),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: context.isDarkMode ? const Color(0xff959595) : const Color(0xff555555),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                songs[index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                songs[index].artist,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 14);
      },
      itemCount: songs.length,
    );
  }
}
