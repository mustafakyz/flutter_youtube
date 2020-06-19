class VideoSearch {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  VideoSearch({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory VideoSearch.fromMap(Map<String, dynamic> snippet) {
    return VideoSearch(
      id: snippet['id']['videoId'],
      title: snippet['snippet']['title'],
      thumbnailUrl: snippet['snippet']['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
    );
  }
}