import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../utils/permission_helper.dart';

class MusicProvider with ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  List<ArtistModel> _artists = [];
  List<PlaylistModel> _playlists = [];

  String _status = 'Loading...';

  List<SongModel> get songs => _songs;
  List<AlbumModel> get albums => _albums;
  List<ArtistModel> get artists => _artists;
  List<PlaylistModel> get playlists => _playlists;
  String get status => _status;

  Future<void> loadMusicData() async {
    final permissionGranted = await PermissionHelper.requestAudioPermission();

    if (permissionGranted) {
      _songs = await _audioQuery.querySongs();
      _albums = await _audioQuery.queryAlbums();
      _artists = await _audioQuery.queryArtists();
      _playlists = await _audioQuery.queryPlaylists();

      _status = 'Music loaded ✅';
    } else {
      _status = 'Permission denied ❌';
    }

    notifyListeners();
  }
}
