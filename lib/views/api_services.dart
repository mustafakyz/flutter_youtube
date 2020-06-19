import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:proje1/views/searchvideo.dart';
import 'package:proje1/views/video.dart';
import 'package:proje1/views/keys.dart';
import 'package:proje1/views/model.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId,String pageToken}) async {
    if(["", null, false, 0].contains(pageToken)){
        _nextPageToken=pageToken;
    }
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
  Future<List<VideoSearch>> fetchVideosSearch({String video}) async {
    print("asd");
    final String uri =
      'https://www.googleapis.com/youtube/v3/search?part=snippet' +
          '&maxResults=20&type=video&q=$video&key='+API_KEY;

    // Get Playlist Videos
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      
       List<dynamic> videosJson = data['items'];
       
      // Fetch first eight videos from uploads playlist
      List<VideoSearch> videos = List<VideoSearch>();
      videosJson.forEach(
        (json) => videos.add(
          VideoSearch.fromMap(json),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  

}