import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileInfoCubit()..getUser(),
        ),
        BlocProvider(
          create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
        ),
      ],
      child: Scaffold(
        appBar: const BasicAppBar(
          title: Text('Profile'),
          backgroundColor: Color(0xff2C2B2B),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileInfo(context),
            const SizedBox(height: 30),
            _favoriteSongs(),
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(state.userEntity.imageURL!),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(state.userEntity.email!,
                    style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 10),
                Text(
                  state.userEntity.fullName!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            );
          } else if (state is ProfileInfoFailure) {
            return const Center(child: Text('Try again later'));
          }
          return Container();
        },
      ),
    );
  }

  Widget _favoriteSongs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FAVORITE SONGS"),
          const SizedBox(height: 20),
          BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
            builder: (context, state) {
              if (state is FavoriteSongsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FavoriteSongsLoaded) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.favoriteSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final song = state.favoriteSongs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SongPlayerPage(
                                songEntity: state.favoriteSongs[index])));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Album Cover Image
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                  AppURLs.coverImageUrl(
                                      song.artist, song.title),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Song Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  song.artist,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                song.duration.toString().replaceAll('.', ':'),
                                style: const TextStyle(fontSize: 14),
                              ),
                              FavoriteButton(
                                songEntity: song,
                                key: UniqueKey(),
                                function: () {
                                  context
                                      .read<FavoriteSongsCubit>()
                                      .removeSong(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is FavoriteSongsFailure) {
                return const Center(child: Text('Try again later'));
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
