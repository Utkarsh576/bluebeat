import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import '../utils/permission_helper.dart';

class MusicProvider with ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> _songs = [];
  List<AlbumModel> _albums = [];
  List<ArtistModel> _artists = [];
  List<PlaylistModel> _playlists = [];

  SongModel? _currentSong;
  bool _isPlaying = false;
  String _status = 'Loading...';

  // Getters
  List<SongModel> get songs => _songs;
  List<AlbumModel> get albums => _albums;
  List<ArtistModel> get artists => _artists;
  List<PlaylistModel> get playlists => _playlists;
  SongModel? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  String get status => _status;

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> loadMusicData() async {
    final permissionGranted = await PermissionHelper.requestAudioPermission();

    if (permissionGranted) {
      _songs = await _audioQuery.querySongs();
      _albums = await _audioQuery.queryAlbums();
      _artists = await _audioQuery.queryArtists();
      _playlists = await _audioQuery.queryPlaylists();

      _status = _songs.isNotEmpty ? 'Music loaded ✅' : 'No songs found';
    } else {
      _status = 'Permission denied ❌';
    }

    notifyListeners();
  }

  Future<void> playSong(SongModel song) async {
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      await _audioPlayer.play();
      _currentSong = song;
      _isPlaying = true;
      notifyListeners();

      _audioPlayer.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error playing song: $e");
    }
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  void playNext() {
    if (_currentSong == null) return;

    final currentIndex = _songs.indexOf(_currentSong!);
    if (currentIndex + 1 < _songs.length) {
      playSong(_songs[currentIndex + 1]);
    }
  }

  void stop() {
    _audioPlayer.stop();
    _isPlaying = false;
    _currentSong = null;
    notifyListeners();
  }
}
