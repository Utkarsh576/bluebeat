import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../providers/music_provider.dart';
import '../../widgets/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  final audioQuery = OnAudioQuery();
  dynamic selectedDetail;

  final List<String> categories = [
    '🎵 Songs',
    '💿 Albums',
    '👤 Artists',
    '📁 Playlists',
    '📂 Folders',
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<MusicProvider>(context, listen: false).loadMusicData();

    // ✅ Show status bar only
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("BlueBeat"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings tapped")),
              );
            },
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, Listener 👋", style: AppTextStyles.headline),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white54),
                    hintText: 'Search songs...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final selected = selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                          selectedDetail = null;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.primaryBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryBlue),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    selectedDetail != null
                        ? _buildDetailView()
                        : _buildCategoryContent(provider),
                    if (provider.currentSong != null)
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: MiniPlayer(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(MusicProvider provider) {
    switch (selectedCategoryIndex) {
      case 0: // Songs
        if (provider.songs.isEmpty) {
          return Center(child: Text(provider.status, style: AppTextStyles.subtext));
        }
        return ListView.builder(
          itemCount: provider.songs.length,
          itemBuilder: (_, index) {
            final song = provider.songs[index];
            return ListTile(
              leading: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white),
              ),
              title: Text(
                song.title.length > 50 ? "${song.title.substring(0, 50)}..." : song.title,
                style: AppTextStyles.body,
              ),
              subtitle: Text(song.artist ?? 'Unknown', style: AppTextStyles.subtext),
              trailing: const Icon(Icons.play_arrow, color: Colors.white),
              onTap: () => provider.playSong(song), // 👈 play song on tap
            );
          },
        );

      case 1: // Albums
        return ListView.builder(
          itemCount: provider.albums.length,
          itemBuilder: (_, index) {
            final album = provider.albums[index];
            return ListTile(
              onTap: () => setState(() => selectedDetail = album),
              leading: QueryArtworkWidget(
                id: album.id,
                type: ArtworkType.ALBUM,
                nullArtworkWidget: const Icon(Icons.album, color: Colors.white),
              ),
              title: Text(album.album, style: AppTextStyles.body),
              subtitle: Text(album.artist ?? '', style: AppTextStyles.subtext),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
            );
          },
        );

      case 2: // Artists
        return ListView.builder(
          itemCount: provider.artists.length,
          itemBuilder: (_, index) {
            final artist = provider.artists[index];
            return ListTile(
              onTap: () => setState(() => selectedDetail = artist),
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(artist.artist, style: AppTextStyles.body),
              subtitle: Text("${artist.numberOfTracks} tracks", style: AppTextStyles.subtext),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
            );
          },
        );

      case 3:
        return const Center(
          child: Text("Playlist support coming soon!", style: TextStyle(color: Colors.white70)),
        );

      case 4:
        return const Center(
          child: Text("Folder view coming soon", style: TextStyle(color: Colors.white70)),
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildDetailView() {
    final bool isAlbum = selectedDetail is AlbumModel;
    final int id = selectedDetail.id;
    final String title = isAlbum ? selectedDetail.album : selectedDetail.artist;

    final Future<List<SongModel>> songsFuture = audioQuery.queryAudiosFrom(
      isAlbum ? AudiosFromType.ALBUM_ID : AudiosFromType.ARTIST_ID,
      id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => setState(() => selectedDetail = null),
            ),
            Expanded(
              child: Text(title, style: AppTextStyles.headline, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<List<SongModel>>(
            future: songsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final songs = snapshot.data!;
              if (songs.isEmpty) {
                return Center(
                  child: Text("No songs available", style: AppTextStyles.subtext),
                );
              }

              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(
                      song.title.length > 50
                          ? "${song.title.substring(0, 50)}..."
                          : song.title,
                      style: AppTextStyles.body,
                    ),
                    subtitle: Text(song.artist ?? 'Unknown', style: AppTextStyles.subtext),
                    trailing: const Icon(Icons.play_arrow, color: Colors.white),
                    onTap: () => Provider.of<MusicProvider>(context, listen: false).playSong(song),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
