class AppURLs {
  static String coverImageUrl(String artist, String title) {
    final encodedArtistTitle = Uri.encodeComponent('$artist - $title');
    return '${AppURLs.coverFirestorage}$encodedArtistTitle.jpg?${AppURLs.mediaAlt}';
  }

  static const coverFirestorage =
      'https://firebasestorage.googleapis.com/v0/b/spotify-clone-e9f3b.appspot.com/o/covers%2F';
  static const songFirestorage =
      'https://firebasestorage.googleapis.com/v0/b/spotify-clone-e9f3b.appspot.com/o/songs%2F';
  static const mediaAlt = 'alt=media';
  static const defaultImage =
      'https://cdn-icons-png.flaticon.com/512/10542/10542486.png';
}
